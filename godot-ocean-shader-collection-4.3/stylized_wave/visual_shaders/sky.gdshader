shader_type sky;
render_mode use_half_res_pass;

uniform vec3 sky_color : source_color;
uniform vec3 horizion_color : source_color;

void sky() {
	float sky = clamp((EYEDIR.y +0.015) / 0.003, 0, 1);
	vec3 blend = mix(horizion_color,sky_color, sky);
	COLOR = blend;
}
