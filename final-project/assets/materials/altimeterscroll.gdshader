shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float speed = 1.0;
uniform float alpha = 0.3; // 0 = invisible, 1 = fully visible

void fragment() {
    vec2 uv = UV;
    uv.x += TIME * speed;

    vec4 tex = texture(TEXTURE, uv);
    tex.a *= alpha; // apply transparency

    COLOR = tex;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
