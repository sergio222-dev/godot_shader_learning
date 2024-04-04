shader_type canvas_item;

uniform float exposure: hint_range(0.0, 4.0, 0.1) = 1.;
uniform bool s_gamma = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 col = texture(TEXTURE, UV);
	
	if (s_gamma) col = pow(col, vec4(.44));
	
	col *= exposure;
	
	if (s_gamma) col = pow(col, vec4(2.2));
	
	if (col.r > 1. || col.g > 1. || col.b > 1.) COLOR = col;
	else COLOR = vec4(.0);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
