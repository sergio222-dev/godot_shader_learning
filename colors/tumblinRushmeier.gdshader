shader_type canvas_item;

uniform float exposure: hint_range(0.0, 4.0, 0.1) = 1.;
uniform bool s_gamma = false;
uniform float l_max: hint_range(1.0, 10.0, 10.) = 1.;
uniform float c_max: hint_range(1.0, 400.0, .1) = 1.;
uniform sampler2D lum_tex: filter_nearest_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 luminance(vec3 col) {
	float d = dot(col, vec3(.299, .587, .114));
	return vec3(d);
}

float log10(float val) {
	return log(val)/log(10);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 col = texture(TEXTURE, UV);
	
	if (s_gamma) col = pow(col, vec4(.44));
	
	//col *= exposure;
	
	float lin = luminance(col.rgb).r;
	
	float l_avg = textureLod(lum_tex,UV, 10.).r;
	
	float logLrw = log10(l_avg) + 0.84;
    float alphaRw = 0.4 * logLrw + 2.92;
    float betaRw = -0.4 * logLrw * logLrw - 2.584 * logLrw + 2.0208;
    float Lwd = l_max / sqrt(c_max);
    float logLd = log10(Lwd) + 0.84;
    float alphaD = 0.4 * logLd + 2.92;
    float betaD = -0.4 * logLd * logLd - 2.584 * logLd + 2.0208;
    float Lout = pow(lin, alphaRw / alphaD) / l_max * pow(10.0, (betaRw - betaD) / alphaD) - (1.0 / c_max);
	
	col.rgb = col.rgb / lin * Lout;
	
	if (s_gamma) col = pow(col, vec4(2.2));
	
	col.rgb = clamp(col.rgb, .0, 1.);
	
	COLOR.rgb = col.rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
