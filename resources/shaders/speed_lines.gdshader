shader_type spatial;
render_mode blend_mix, unshaded;

uniform sampler2D noise: repeat_enable;
uniform vec4 line_color: source_color;
uniform float line_count: hint_range(0.0, 2.0, 0.05) = 0.5;
uniform float line_density: hint_range(0.0, 1.0) = 0.5;
uniform float line_falloff: hint_range(0.0, 1.0) = 0.25;
uniform float mask_size: hint_range(0.0, 1.0) = 0.1;
uniform float mask_edge: hint_range(0.0, 1.0) = 0.5;
uniform float animation_speed: hint_range(1.0, 20.0) = 0.5;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

float inv_lerp(float from, float to, float value) {
    return (value - from) / (to - from);
}

vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat) {
    vec2 dir = uv - center;
    float radius = length(dir) * 2.0;
    float angle = atan(dir.y, dir.x) * (1.0 / (PI * 2.0));
    return mod(vec2(radius * zoom, angle * repeat), 1.0);
}

vec2 rotate_uv(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x
    ) + pivot;
}

void fragment() {
    vec2 rotated_uv = rotate_uv(SCREEN_UV, vec2(0.5), floor(fract(TIME) * animation_speed));
    vec2 polar_uv = polar_coordinates(rotated_uv, vec2(0.5), 0.01, line_count);
    
    vec3 scene_color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
    vec3 lines = texture(noise, polar_uv).rgb;
    
    float mask_value = length(SCREEN_UV - vec2(0.5));
    float mask = inv_lerp(mask_size, mask_edge, mask_value);
    float result = 1.0 - (mask * line_density);
    
    result = smoothstep(result, result + line_falloff, lines.r);
    
    ALBEDO = mix(scene_color, line_color.rgb, result);
    ALPHA = min(line_color.a, result);
}
