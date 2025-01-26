shader_type spatial;
render_mode cull_back;

uniform vec4 bubble_color: source_color;
uniform float fresnel_amount = 5.0;
uniform sampler2D environment: source_color, hint_default_transparent;

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
	
	
	
	//vec4 environment_sample = texture(environment, P)
	ALBEDO = bubble_color.rgb;
	ALPHA = bubble_color.a * fresnel(fresnel_amount, NORMAL, VIEW) * particle_alpha;
	METALLIC = 1.0;
	ROUGHNESS = .0;
}

void light() {
	float base_lighting = clamp((ATTENUATION) * (dot(LIGHT, NORMAL)), 0.0, 1.0);
	
	DIFFUSE_LIGHT = LIGHT_COLOR * base_lighting;
	//SPECULAR_LIGHT = vec3(0.0);
}
