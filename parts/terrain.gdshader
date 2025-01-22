shader_type spatial;
uniform vec3 color : source_color;
uniform sampler2D normal;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color;
	NORMAL_MAP = texture(normal, 1e6 * UV).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
