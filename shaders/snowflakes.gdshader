shader_type canvas_item;

uniform sampler2D atlas_tex : source_color;
uniform vec4 region_px = vec4(0.0, 0.0, 9.0, 9.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 atlas_size = vec2(textureSize(atlas_tex, 0));
	
	vec2 uv_offset = region_px.xy / atlas_size;
	vec2 uv_size = region_px.zw / atlas_size;
	
	vec2 uv_region = uv_offset + UV * uv_size;
	
	COLOR = texture(atlas_tex, uv_region);
}