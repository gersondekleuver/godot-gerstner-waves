shader_type spatial;

// Basic properties
uniform vec3 albedo : source_color;
uniform vec3 albedo_fresnel : source_color;
uniform vec3 height_based_albedo : source_color;

// Extra properties
uniform float roughness : hint_range(0.0, 1.0) = 0;
uniform float metallic : hint_range(0.0, 1.0) = 0.2;
uniform float fresnel_effect : hint_range(3.0, 20, 0.5) = 5;
uniform bool height_based_color = true;
uniform vec2 height_based_color_settings = vec2(3.0,2.0);

// normal texture variables
uniform sampler2D normal_texture_1;
uniform sampler2D normal_texture_2;
uniform float normal_texture_speed_1 : hint_range(0.0, 2.0, 0.1) = 0.3;
uniform float normal_texture_speed_2 : hint_range(0.0, 2.0, 0.1) = 0.3;
uniform vec2 normal_texture_dir_1 = vec2(0.0, 2.0);
uniform vec2 normal_texture_dir_2 = vec2(0.2, 0.2);

// Height noise variable
uniform sampler2D height_map;
uniform float height_noise_amplitude : hint_range(1.0, 10.0, 0.1) = 5.0;
uniform float height_noise_smoothness : hint_range(0.0, 300.0, 1.0) = 25.0;
uniform float height_noise_speed : hint_range(0.0, 0.25, 0.005) = 0.025;
uniform float central_noise_e : hint_range(0.001, 1.0, 0.005) = 0.025;

// Wave variables
// float vec4 ( dir x, dir y, smoothness, wavelength )
uniform vec4 wave_1 = vec4(1,1,0.07,5);
uniform vec4 wave_2 = vec4(1,2,0.2,10);
uniform vec4 wave_3 = vec4(1,3,0.15,15);
uniform vec4 wave_4 = vec4(2,1,0.1,20);
uniform vec4 wave_5 = vec4(3,1,0.1,30);

// Persitent variables
varying float height;
varying vec3 world_pos;


vec3 get_noise_height(sampler2D map,vec2 pos, float y){
	vec3 wave = texture(map, pos / height_noise_smoothness + height_noise_speed * TIME).rgb;
	return max(wave * height_noise_amplitude / 10.0 + y, wave / 5.0 + y);
}

vec3 gerstner_wave(vec4 wave,vec3 pos, inout vec3 tangent, inout vec3 binormal){
	float wave_length = wave.w;
	float s = wave.z;
	float k = 2.0 * PI / wave_length;
	vec2 d = normalize(wave.xy);
	float f = k * (dot(d,pos.xz) - sqrt(9.8 / k) * TIME);
	float a = s / k;

	float sin_f = sin(f);
	float cos_f = cos(f);

	tangent += vec3(
		- d.x * d.x * (s * sin_f),
		d.x * (s * cos_f),
		-d.x * d.y * (s * sin_f)
	);
	binormal += vec3(
		-d.x * d.y * (s * sin_f),
		d.y * (s * cos_f),
		- d.y * d.y * (s * sin_f)
	);

	return vec3(a * sin_f,
	d.x * (a * cos_f),
	d.y * (a * cos_f));
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	vec3 tangent = vec3(1, 0, 0);
	vec3 binormal = vec3(0, 0, 1);
	
	vec3 p = gerstner_wave(wave_1, world_pos, tangent, binormal)
		+ gerstner_wave(wave_2, world_pos, tangent, binormal)
		+ gerstner_wave(wave_3, world_pos, tangent, binormal)
		+ gerstner_wave(wave_4, world_pos, tangent, binormal)
		+ gerstner_wave(wave_5, world_pos, tangent, binormal);

	
	VERTEX.y = p.x + get_noise_height(height_map, world_pos.xz, p.x).r;
	VERTEX.x += p.y; 
	VERTEX.z += p.z;
	
	// store height in presistent variable.
	height = VERTEX.y;
	
	// TODO - Settle on best approach for normals
	
	// Adding central difference for recalculating noise normals.
	vec2 e = vec2(central_noise_e, 0.0);
	
	NORMAL = normalize(vec3(
		get_noise_height(height_map, world_pos.xz - e , height).r
		- get_noise_height(height_map, world_pos.xz + e , height).r,
		2.0 * e.x,
		get_noise_height(height_map, world_pos.xz - e.yx , height).r
		- get_noise_height(height_map, world_pos.xz + e.yx , height).r
		));
		
	// Used to calculate normals for gerstner waves 
	// Added this to decrease the harshness of the texture.
	NORMAL += normalize(cross(binormal, tangent));

}

float fresnel(float f, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(
		normalize(normal), normalize(view)), 0.0, 1.0 )),
	f);
}

void fragment() {
	vec2 time_1 = TIME * normal_texture_dir_1 * normal_texture_speed_1;
	vec2 time_2 = TIME * normal_texture_dir_2 * normal_texture_speed_2;
	
	vec3 normal = mix(
		texture(normal_texture_1, world_pos.xz + time_1).rgb,
		texture(normal_texture_2, world_pos.xz + time_2).rgb,
		0.5);


	float basic_fresnel = fresnel(fresnel_effect, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo_fresnel, basic_fresnel);
	vec3 final_color;
	
	// Simplistic heightbased color.
	if (height_based_color){
		final_color = mix(
		height_based_albedo, surface_color,
		normalize(vec2(distance(height, height_based_color_settings.x), height_based_color_settings.y)).x
		);
	}
	else {
		final_color = surface_color;
	}

	// TBA foam based on determinant.

	ALBEDO = final_color;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal;
}