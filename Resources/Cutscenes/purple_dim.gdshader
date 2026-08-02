shader_type canvas_item;
render_mode blend_add;

uniform vec4 tint_color : source_color = vec4(0.125, 0.074, 0.161, 1.0);

// (0.0 = black, 1.0 = original brightness)
uniform float dim_factor : hint_range(0.0, 1.0) = 0.3; 

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    vec3 dimmed_base = tex_color.rgb * dim_factor;
    
    vec3 mixed_rgb = dimmed_base + (tint_color.rgb * tex_color.a);
    
    COLOR = vec4(mixed_rgb, tex_color.a);
}
