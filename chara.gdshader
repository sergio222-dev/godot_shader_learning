#define PI 3.14

shader_type canvas_item;

uniform int SAMPLES: hint_range(0, 32, 4);
uniform float WIDTH: hint_range(1.0, 40.0, 2.);
uniform vec4 OUTLINE_COLOR: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 iRes = 1. / SCREEN_PIXEL_SIZE;
	
	float testAplha = 0.;
	float angle = 0.;
	for (int i = 0; i < SAMPLES; i++) {
		angle += 1./(float(SAMPLES)/2.) * PI;
		vec2 testPoint = vec2(UV.x + WIDTH * cos(angle) * SCREEN_PIXEL_SIZE.x, UV.y + WIDTH * sin(angle) * SCREEN_PIXEL_SIZE.x);
		vec4 sample = texture(TEXTURE, testPoint);
		testAplha = max(testAplha, sample.a);
	}
	
	vec4 outLineColor = mix(vec4(0.), OUTLINE_COLOR, testAplha);
	vec4 pc1 = mix(outLineColor, COLOR, COLOR.a);
	
	// MSAA
	angle = 0.;
	vec4 accumColor = pc1;
	for (int i = 0; i < SAMPLES; i++) {
		angle += 1./(float(SAMPLES)/2.) * PI;
	}
	
	
	COLOR = pc1;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
