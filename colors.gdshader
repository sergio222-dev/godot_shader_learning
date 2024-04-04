shader_type canvas_item;

uniform float contrast: hint_range(0.0, 1.0, 0.1);
uniform float brightness: hint_range(0.0, 1.0, 0.1);
uniform float saturation: hint_range(-1.0, 8.0, 0.1);
uniform float exposure1: hint_range(.5, 8.0, 0.1);
uniform float gamma = 1.;
uniform bool u2ToneMap = false;
uniform bool filmicToneMap = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec3 Uncharted2ToneMapping(vec3 color)
{
	float A1 = 0.15;
	float B1 = 0.50;
	float C1 = 0.10;
	float D1 = 0.20;
	float E1 = 0.02;
	float F1 = 0.30;
	float W1 = 11.2;
	float exposure = 2.;
	color *= exposure;
	color = ((color * (A1 * color + C1 * B1) + D1 * E1) / (color * (A1 * color + B1) + D1 * F1)) - E1 / F1;
	float white = ((W1 * (A1 * W1 + C1 * B1) + D1 * E1) / (W1 * (A1 * W1 + B1) + D1 * F1)) - E1 / F1;
	color /= white;
	color = pow(color, vec3(1. / gamma));
	return color;
}

vec3 filmicToneMapping(vec3 color)
{
	color = max(vec3(0.), color - vec3(0.004));
	color = (color * (6.2 * color + .5)) / (color * (6.2 * color + 1.7) + 0.06);
	return color;
}

void fragment() {
	float p = .0;
	if (UV.y < .33) p = .44;
	if (UV.y >= .33 && UV.y < .66) p = 1.;
	if (UV.y >= .66) p = 2.2;
	
	float d = pow(UV.x, p);
	COLOR.rgb = vec3(d);
	COLOR.a = 1.;
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
