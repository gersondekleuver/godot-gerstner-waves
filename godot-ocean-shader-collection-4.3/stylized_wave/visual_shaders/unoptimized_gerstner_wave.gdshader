shader_type spatial;

// Basic properties
uniform vec3 albedo : source_color;
uniform float roughness : hint_range(0.0, 1.0) = 0;
uniform float metallic : hint_range(0.0, 1.0) = 0.2;

// Extra properties
uniform vec3 albedo_fresnel : source_color;
uniform vec3 albedo_foam : source_color;

// Texture noise variables
uniform sampler2D texture_normal;
uniform sampler2D texture_normal_2;
uniform float texture_noise_speed_1 : hint_range(0.0, 30.0, 1) = 10;
uniform float texture_noise_speed_2 : hint_range(0.0, 30.0, 1) = 10;
uniform vec2 texture_dir_1 = vec2(0.0, 2.0);
uniform vec2 texture_dir_2 = vec2(0.2, 0.2);

// Height noise variable
uniform sampler2D height_map;
uniform float amplitude_height_noise : hint_range(0.0, 10.0, 0.1) = 1.3;
uniform float height_noise_smoothness : hint_range(0.0, 300.0, 1.0) = 9.0;
uniform float height_noise_speed : hint_range(0.0, 0.25, 0.005) = 0.025;

// Wave variables
// float vec4 (dir x, dir y, smoothness, wavelength)
uniform vec4 wave_1 = vec4(1,1,0.07,5);
uniform vec4 wave_2 = vec4(1,2,0.2,10);
uniform vec4 wave_3 = vec4(1,3,0.15,15);
uniform vec4 wave_4 = vec4(2,1,0.1,20);
uniform vec4 wave_5 = vec4(3,1,0.1,30);

// Persitent variables
varying float height;
varying vec3 world_pos;

// Misc
uniform float pi = 3.14159;

float get_height(vec2 pos, float y){
	float wave = texture(height_map, pos / height_noise_smoothness 
		+ TIME * height_noise_speed).r;
	return max(wave * amplitude_height_noise * y, wave / 3.5); // magic numbers
}

vec3 gerstner_wave(vec4 wave,vec3 pos, inout vec3 tangent, inout vec3 binormal){
	float s = wave.z;
	float k = 2.0 * pi / wave.w;
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
	return vec3(a * sin_f, d.x * (a * cos_f), d.y * (a * cos_f));
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vec3 tangent = vec3(1, 0, 0);
	vec3 binormal = vec3(0, 0, 1);
	vec2 e = vec2(0.5, 0.0);

	vec3 p = gerstner_wave(wave_1, world_pos, tangent, binormal) 
		+ gerstner_wave(wave_2, world_pos, tangent, binormal)
		+ gerstner_wave(wave_3, world_pos, tangent, binormal)
		+ gerstner_wave(wave_4, world_pos, tangent, binormal)
		+ gerstner_wave(wave_5, world_pos, tangent, binormal);
		
	height = p.x;
	
	NORMAL = normalize(cross(binormal, tangent)) + normalize(vec3(
		get_height(world_pos.xz - e , height) - 
		get_height(world_pos.xz + e , height),
		2.0 * e.x,
		get_height(world_pos.xz - e.yx , height) - 
		get_height(world_pos.xz + e.yx , height)
	));
	
	VERTEX.y = height + get_height(world_pos.xy, height);
	VERTEX.x += p.y;
	VERTEX.z += p.z;
}

float fresnel(float f, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), f);
}

void fragment() {
	vec2 time = (TIME * texture_dir_1) * texture_noise_speed_1;
	vec2 time_2 = (TIME * texture_dir_2) * texture_noise_speed_2;
	
	vec3 normal = mix(
		texture(texture_normal, world_pos.xz + time).rgb, 
		texture(texture_normal_2, world_pos.xz + time_2).rgb, 
		0.5
	);
	
	float basic_fresnel = fresnel(7, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo_fresnel, basic_fresnel);
	vec3 final_color = mix(albedo_foam, surface_color, 
		normalize(vec2(distance(height, 1.2), 0.7)).x); // magic numbers

	ALBEDO = final_color;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal;
}
