import numpy as np
from PIL import Image
import rasterio
from rasterio.windows import from_bounds
from rasterio.warp import transform
import trimesh


def normalize(elevation):
    min_elev = elevation.min()
    max_elev = elevation.max()
    scale = (elevation - min_elev) / (max_elev - min_elev)
    return scale


def elevation_to_gray(elevation):
    return (255 * normalize(elevation)).astype(np.uint8)


def elevation_to_rgb(elevation):
    scale = normalize(elevation)
    rgb = (scale * (256**3 - 1)).astype(np.uint32)
    r = (rgb >> 16) & 255
    g = (rgb >> 8) & 255
    b = rgb & 255
    return np.dstack((r, g, b)).astype(np.uint8)


def extract_region(path: str, lat: float, lon: float, size_meters: float) -> np.ndarray:
    # https://prd-tnm.s3.amazonaws.com/index.html?prefix=StagedProducts/Elevation/1m/Projects/AZ_PimaCounty_2021_B21/
    with rasterio.open(path) as src:
        # Convert lat/lon to the file's coordinates.
        lon_lat_to_crs = transform("EPSG:4326", src.crs, [lon], [lat])
        x, y = lon_lat_to_crs[0][0], lon_lat_to_crs[1][0]
        half_size = size_meters / 2
        min_x, max_x = x - half_size, x + half_size
        min_y, max_y = y - half_size, y + half_size
        window = from_bounds(min_x, min_y, max_x, max_y, src.transform)
        # Read the elevation data
        return src.read(1, window=window)


def main():
    lat, lon = 32.1283421, -110.6429937
    # Go past what we plan to use for easier clipping in Blender.
    # region = extract_region(
    #     path="ignore/USGS_1M_12_x53y356_AZ_PimaCounty_2021_B21.tif",
    #     lat=32.1283421,
    #     lon=-110.6429937,
    #     size_meters=110,
    # )
    # lat, lon = 32.21493, -111.00046
    clip = dict(lat=32.21493, lon=-111.00046, size_meters=2600)
    region1 = extract_region(
        path="ignore/USGS_1M_12_x49y357_AZ_PimaCounty_2021_B21.tif", **clip
    )
    region2 = extract_region(
        path="ignore/USGS_1M_12_x50y357_AZ_PimaCounty_2021_B21.tif", **clip
    )
    scale = 10
    region = np.hstack([region1, region2])[::scale, ::scale]
    # Save images.
    # options = dict(lossless=True)
    options = dict()
    Image.fromarray(elevation_to_gray(region)).save(
        "ignore/elevation_gray.webp", **options
    )
    # RGB was for high res elevation, but I haven't used it, and it's not
    # really understandable to look at.
    # Image.fromarray(elevation_to_rgb(region)).save("elevation_rgb.webp", **options)
    # Instead just use a mesh export.
    save_heightmap_to_gltf(region / scale, "ignore/elevation.glb")


def save_heightmap_to_gltf(heightmap, filename, scale=1.0):
    # Normalize before starting.
    heightmap = heightmap - heightmap.min()
    # Create an array of vertices (x, z, y).
    height, width = heightmap.shape
    vertices = (
        np.array([(x, heightmap[y, x], y) for y in range(height) for x in range(width)])
        - np.array([width, 0, height]) * 0.5
        + 0.5
    )
    # Create faces (two triangles per grid cell).
    faces = []
    for y in range(height - 1):
        for x in range(width - 1):
            # Get indices of the vertices in the grid.
            v1 = y * width + x
            v2 = y * width + x + 1
            v3 = (y + 1) * width + x
            v4 = (y + 1) * width + x + 1
            # Two triangles for each grid square.
            faces.append([v1, v2, v3])
            faces.append([v3, v2, v4])
    # Create the mesh and export.
    faces = np.array(faces)
    mesh = trimesh.Trimesh(vertices=vertices * scale, faces=faces)
    mesh.export(filename)
    # print(f"Saved mesh to {filename}")


if __name__ == "__main__":
    main()
