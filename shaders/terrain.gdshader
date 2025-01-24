shader_type spatial;
uniform vec3 color : source_color;
uniform sampler2D normal;
varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	ALBEDO = color;
	NORMAL_MAP = texture(normal, 1e-1 * world_pos.xz).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
