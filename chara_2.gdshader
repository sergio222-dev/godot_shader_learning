shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 c = texture(screen_texture, SCREEN_UV, 0.0);
	COLOR.a = c.a;
	
	//if (c.r > .0 && c.g > .0 && c.b > .0) {
		//COLOR.rgb = vec3(.0);
	//} else {
		//COLOR.rgb = vec3(1.);
	//}
	
	if (c.a > .0) {
		COLOR.rgb = vec3(.0);
	} else {
		COLOR.rgb = vec3(1.);
	}
	
	//COLOR.rgb = c;
	//vec4 c2 = textureLod(screen_texture, SCREEN_UV, 0.0);
	
	//COLOR = mix(vec4(1.), c2, c2.a);
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
