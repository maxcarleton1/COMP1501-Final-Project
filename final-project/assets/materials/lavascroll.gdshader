shader_type canvas_item;

uniform float speed = 1.0;

void fragment() {
    vec2 uv = UV;
    uv.x += TIME * speed;

    vec4 tex = texture(TEXTURE, uv);

    COLOR = tex;
}