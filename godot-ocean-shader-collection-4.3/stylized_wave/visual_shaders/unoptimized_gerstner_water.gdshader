shader_type spatial;

// Basic properties
uniform vec3 albedo : source_color;
uniform vec3 albedo_fresnel : source_color;
uniform vec3 aldedo_foam : source_color;
uniform float roughness : hint_range(0.0, 1.0) = 0;
uniform float metallic : hint_range(0.0, 1.0) = 0.2;

// Texture noise variables
uniform sampler2D texture_normal;
uniform sampler2D texture_normal_2;
uniform float texture_noise_speed_1 : hint_range(0.0, 30.0, 1) = 10;
uniform float texture_noise_speed_2 : hint_range(0.0, 30.0, 1) = 10;
uniform vec2 texture_dir_1 = vec2(0.0, 2.0);
uniform vec2 texture_dir_2 = vec2(0.2, 0.2);

// Height noise variable
uniform sampler2D height_map_2;
uniform float amplitude_height_noise_2 : hint_range(0.0, 10.0, 0.1) = 1.3;
uniform float height_noise_smoothness_2 : hint_range(0.0, 300.0, 1.0) = 9.0;
uniform float height_noise_speed_2 : hint_range(0.0, 0.25, 0.005) = 0.025;


// Wave variables
// float vec4 ( dir x, dir y, smoothness, wavelength )
uniform vec4 wave_1 = vec4(1,1,0.07,5);
uniform vec4 wave_2 = vec4(1,2,0.2,10);
uniform vec4 wave_3 = vec4(1,3,0.15,15);
uniform vec4 wave_4 = vec4(2,1,0.1,20);
uniform vec4 wave_5 = vec4(3,1,0.1,30);


// Misc
uniform float pi = 3.14159;

// Persitent variables
varying float height;
varying vec3 world_pos;

vec2 scale_on_height(float y)
{
	// TODO finding the local max wave height from texture.
	// Magic numbers
	return normalize(vec2(distance(y, 1.2), 0.7));
}

float GetHeight(vec2 pos, float y){
	float wave = texture(height_map_2, pos / height_noise_smoothness_2 + TIME * height_noise_speed_2).r;

	float noise_2 = max(wave * amplitude_height_noise_2 * y, wave / 3.5);
	return noise_2;
}
float height_wave(vec3 pos, float y){
	float wave = texture(height_map_2, pos.xz / height_noise_smoothness_2 + TIME * height_noise_speed_2).r;
	float noise_2 = max(wave * amplitude_height_noise_2 * y, wave / 3.5);
	return noise_2;
}

vec3 gerstner_wave(vec4 wave,vec3 pos, inout vec3 tangent, inout vec3 binormal){
	float wave_length = wave.w;
	float s = wave.z;
	float k = 2.0 * pi / wave_length;
	float c = sqrt(9.8 / k);
	vec2 d = normalize(wave.xy);
	float f = k * (dot(d,pos.xz) - c * TIME);
	float a = s / k;

	tangent += vec3(
		- d.x * d.x * (s * sin(f)),
		d.x * (s * cos(f)),
		-d.x * d.y * (s * sin(f))
	);
	binormal += vec3(
		-d.x * d.y * (s * sin(f)),
		d.y * (s * cos(f)),
		- d.y * d.y * (s * sin(f))
	);

	return vec3(a * sin(f),
	d.x * (a * cos(f)),
	d.y * (a * cos(f)));
}

void vertex() {
	// Called for every vertex the material is visible on.
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	vec3 tangent = vec3(1, 0, 0);
	vec3 binormal = vec3(0, 0, 1);
	vec3 p;
	p = gerstner_wave(wave_1, world_pos, tangent, binormal);
	p += gerstner_wave(wave_2, world_pos, tangent, binormal);
	p += gerstner_wave(wave_3, world_pos, tangent, binormal);
	p += gerstner_wave(wave_4, world_pos, tangent, binormal);
	p += gerstner_wave(wave_5, world_pos, tangent, binormal);



	height = p.x;
	VERTEX.y = height + height_wave(world_pos, height);
	VERTEX.x += p.y;
	VERTEX.z += p.z;
	vec3 normal = normalize(cross(binormal, tangent));

	NORMAL = normal;

	vec2 e = vec2(0.5, 0.0);
	normal += normalize(vec3(
		GetHeight(world_pos.xz - e , height) - GetHeight(world_pos.xz + e , height),
		2.0 * e.x,
		GetHeight(world_pos.xz - e.yx , height) - GetHeight(world_pos.xz + e.yx , height)
		));
	NORMAL = normal;
}


float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}



void fragment() {
	 //Called for every pixel the material is visible on.
	vec2 time = (TIME * texture_dir_1) * texture_noise_speed_1;
	vec2 time_2 = (TIME * texture_dir_2) * texture_noise_speed_2;

	vec3 normal = mix(texture(texture_normal, world_pos.xz + time).rgb, texture(texture_normal_2, world_pos.xz + time_2).rgb, 0.5);

	float basic_fresnel = fresnel(7, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo_fresnel, basic_fresnel);
	vec3 final_color = mix(aldedo_foam, surface_color, scale_on_height(height).x);

	ALBEDO = final_color;

	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal;

}
