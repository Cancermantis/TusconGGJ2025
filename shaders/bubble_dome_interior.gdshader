shader_type spatial;

uniform vec4 bubble_color: source_color;
uniform float alpha_exponent = 2.0;

varying vec3 NORMAL_WORLD;

void vertex() {
	// Called for every vertex the material is visible on.
	NORMAL_WORLD = NORMAL * MODEL_NORMAL_MATRIX;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//ALPHA = pow(length(abs(SCREEN_UV-vec2(.5)) * 2.0), alpha_exponent) * bubble_color.a;
	ALPHA = smoothstep(-.0,1.0, 1.0 - dot(CAMERA_DIRECTION_WORLD, NORMAL_WORLD)) * bubble_color.a;
	ALBEDO = bubble_color.rgb;
	METALLIC = 1.0;
	ROUGHNESS = 0.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
