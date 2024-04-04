shader_type canvas_item;

uniform sampler2D ichannel1: filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ivec2 ts = textureSize(ichannel1, 0);
	vec2 iRes1 = vec2(float(ts.x), float(ts.y)); 
	//vec2 uv1 = 1./vec2(float(ts.x), float(ts.y));
	
	vec2 iRes0 = SCREEN_PIXEL_SIZE;
	
	vec2 rel = iRes1/iRes0;
	vec2 s1 = FRAGCOORD.xy * rel;
	vec2 uv1_r = 1./iRes1;
	vec2 uv1 = vec2(uv1_r.x * s1.x, uv1_r.y * s1.y);
	
	vec4 c = texture(ichannel1, uv1);
	
	//COLOR = c;
	
	if (iRes0.x > 400.) COLOR.r = 1.0;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
