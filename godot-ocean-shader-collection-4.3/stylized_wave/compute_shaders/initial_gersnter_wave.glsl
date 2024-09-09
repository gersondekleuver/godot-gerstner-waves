#[compute]
#version 450

#define COMPUTE_WORK_GROUP_DIM 32

layout(local_size_x = COMPUTE_WORK_GROUP_DIM , local_size_y = COMPUTE_WORK_GROUP_DIM ) in;


// Noise textures 
layout(set = 0, binding = 1, r32f) readonly uniform image2D u_normal_noise_1;
layout(set = 0, binding = 2, r32f) readonly uniform image2D u_normal_noise_2;
layout(set = 0, binding = 3, r32f) readonly uniform image2D u_height_noise_1;

// Normal noise parameters
layout(set = 0, binding = 10) buffer UniformsBuffer {
    int resolution_1;
    int resolution_2;
    int ocean_size_1;
    int ocean_size_2;
    float noise_speed_1;
    float noise_speed_2;
    vec2 noise_dir_1;
    vec2 noise_dir_2;
} u_noise_params;

// Height noise parameters
layout(set = 0, binding = 11) buffer UniformsBuffer {
    float amplitude;
    float smoothness;
    float speed;
} u_height_params;


// Wave variables
layout(set = 0, binding = 12) buffer UniformsBuffer {
    int direction_x;
    int direction_y;
    float smoothness;
    float wavelength;
} u_wave_1;

// Persitent variables
varying float height;
varying vec3 world_pos;

// Constants
uniform float pi = 3.14159;

// float get_height(vec2 pos, float y){
// 	float wave = texture(height_map, pos / height_noise_smoothness 
// 		+ TIME * height_noise_speed).r;
// 	return max(wave * amplitude_height_noise * y, wave / 3.5);
// }

// vec3 gerstner_wave(vec4 wave,vec3 pos, inout vec3 tangent, inout vec3 binormal){
// 	float s = wave.z;
// 	float k = 2.0 * pi / wave.w;
// 	float c = sqrt(9.8 / k);
// 	vec2 d = normalize(wave.xy);
// 	float f = k * (dot(d,pos.xz) - c * TIME);
// 	float a = s / k;

// 	tangent += vec3(
// 		- d.x * d.x * (s * sin(f)),
// 		d.x * (s * cos(f)),
// 		-d.x * d.y * (s * sin(f))
// 	);
// 	binormal += vec3(
// 		-d.x * d.y * (s * sin(f)),
// 		d.y * (s * cos(f)),
// 		- d.y * d.y * (s * sin(f))
// 	);

// 	return vec3(a * sin(f),
// 	d.x * (a * cos(f)),
// 	d.y * (a * cos(f)));
// }

// void vertex() {
// 	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
// 	vec3 tangent = vec3(1, 0, 0);
// 	vec3 binormal = vec3(0, 0, 1);
// 	vec2 e = vec2(0.5, 0.0);
	
// 	// TODO precalculate
// 	vec3 p;
// 	p = gerstner_wave(wave_1, world_pos, tangent, binormal);
// 	p += gerstner_wave(wave_2, world_pos, tangent, binormal);
// 	p += gerstner_wave(wave_3, world_pos, tangent, binormal);
// 	p += gerstner_wave(wave_4, world_pos, tangent, binormal);
// 	p += gerstner_wave(wave_5, world_pos, tangent, binormal);
// 	height = p.x;
	
// 	NORMAL = normalize(cross(binormal, tangent));
// 	NORMAL += normalize(vec3(
// 		get_height(world_pos.xz - e , height) - 
// 		get_height(world_pos.xz + e , height),
// 		2.0 * e.x,
// 		get_height(world_pos.xz - e.yx , height) - 
// 		get_height(world_pos.xz + e.yx , height)
// 		));
// 	VERTEX.y = height + get_height(world_pos.xy, height);
// 	VERTEX.x += p.y;
// 	VERTEX.z += p.z;
// }

// float fresnel(float f, vec3 normal, vec3 view)
// {
// 	return pow((1.0 - clamp(dot(normalize(normal), 
// 		normalize(view)), 0.0, 1.0 )), f);
// }

// void fragment() {
// 	vec2 time = (TIME * texture_dir_1) * texture_noise_speed_1;
// 	vec2 time_2 = (TIME * texture_dir_2) * texture_noise_speed_2;
	
// 	vec3 normal = mix(texture(texture_normal, world_pos.xz + time).rgb, 
// 		texture(texture_normal_2, world_pos.xz + time_2).rgb, 0.5);
// 	float basic_fresnel = fresnel(7, NORMAL, VIEW);
// 	vec3 surface_color = mix(albedo, albedo_fresnel, basic_fresnel);
// 	vec3 final_color = mix(aldedo_foam, surface_color, 
// 		normalize(vec2(distance(height, 1.2), 0.7)).x); // magic numbers

// 	ALBEDO = final_color;
// 	METALLIC = metallic;
// 	ROUGHNESS = roughness;
// 	NORMAL_MAP = normal;
// }
