shader_type spatial;
render_mode cull_back;

uniform vec4 bubble_color: source_color;
uniform float fresnel_amount = 5.0;

varying float particle_alpha;
varying vec3 VERTEX_POSITION_WORLD;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void vertex() {
	particle_alpha = COLOR.a;
	VERTEX_POSITION_WORLD = (vec4(VERTEX, 1.0) * MODELVIEW_MATRIX).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float dist = distance(CAMERA_POSITION_WORLD, VERTEX_POSITION_WORLD);
	float dist_alpha = smoothstep(5.0, 10.0, dist);
	ALBEDO = bubble_color.rgb;
	ALPHA = bubble_color.a * fresnel(fresnel_amount, NORMAL, VIEW) * particle_alpha * dist_alpha;
	METALLIC = 1.0;
	ROUGHNESS = .0;
}

void light() {
	float base_lighting = clamp((ATTENUATION) * (dot(LIGHT, NORMAL)), 0.0, 1.0);
	
	DIFFUSE_LIGHT = LIGHT_COLOR * base_lighting;
	//SPECULAR_LIGHT = vec3(0.0);
}
