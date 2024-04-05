shader_type canvas_item;
uniform float d: hint_range(0.0, 1.0, 0.01) = .0;
uniform float brightness: hint_range(0.0, 1.0, 0.001) = .1;
uniform float amp: hint_range(0.001, 40.0, 0.001) = .005;
uniform bool s_gamma = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 luminance(vec3 col) {
	float l = dot(col, vec3(.299, .587, .114));
	return vec3(l);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 col = texture(TEXTURE, UV);
	
	if (s_gamma) col = pow(col, vec4(.44));
	
	float lin = luminance(col.rgb).r;
	
	float lout = ((d - lin)/(d - lin + 1.)) * amp * - 1. + brightness;
	
	col = col / lin * lout;
	
	col = clamp(col, .0 , 1.);
	
	if (s_gamma) col = pow(col, vec4(2.2));
	
	COLOR.rgb = col.rgb;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
