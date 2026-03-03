shader_type spatial;

uniform sampler2D albedo_tex;
uniform float scale = 0.25;

void fragment() {
	vec3 world_pos = WORLD_POSITION * scale;
	vec3 abs_norm = abs(NORMAL);
	vec3 weights = abs_norm / (abs_norm.x + abs_norm.y + abs_norm.z);

	vec2 uv_x = world_pos.yz;
	vec2 uv_y = world_pos.xz;
	vec2 uv_z = world_pos.xy;

	vec4 tex_x = texture(albedo_tex, uv_x);
	vec4 tex_y = texture(albedo_tex, uv_y);
	vec4 tex_z = texture(albedo_tex, uv_z);

	vec4 triplanar = tex_x * weights.x + tex_y * weights.y + tex_z * weights.z;

	ALBEDO = triplanar.rgb;
	ROUGHNESS = 1.0;
	METALLIC = 0.0;
}
