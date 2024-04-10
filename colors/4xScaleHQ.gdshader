shader_type canvas_item;

uniform float mx : hint_range(-2.0, 2.0) = 1.00; // start smoothing wt.
uniform float k : hint_range(-2.0, 2.0) = -1.10; // wt. decrease factor
uniform float max_w : hint_range(-2.0, 2.0) = 0.75; // max filter weigth
uniform float min_w : hint_range(-2.0, 2.0) = 0.03; // min filter weigth
uniform float lum_add : hint_range(-2.0, 2.0) = 0.33; // effects smoothing

void vertex() {
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	ivec2 texture_size = textureSize(TEXTURE, 0);
	vec4 c = color;

	float x = 0.5 * (1.0 / float(texture_size.x));
	float y = 0.5 * (1.0 / float(texture_size.y));

	const vec4 dt = 1.0*vec4(1.0, 1.0, 1.0, 1.0);

	vec2 dg1 = vec2( x, y);
	vec2 dg2 = vec2(-x, y);

	vec2 sd1 = dg1*0.5;
	vec2 sd2 = dg2*0.5;

	vec2 ddx = vec2(x,0.0);
	vec2 ddy = vec2(0.0,y);

	vec4 t1 = vec4(UV-sd1,UV-ddy);
	vec4 t2 = vec4(UV-sd2,UV+ddx);
	vec4 t3 = vec4(UV+sd1,UV+ddy);
	vec4 t4 = vec4(UV+sd2,UV-ddx);
	vec4 t5 = vec4(UV-dg1,UV-dg2);
	vec4 t6 = vec4(UV+dg1,UV+dg2);

	vec4 i1 = texture(TEXTURE, t1.xy);
	vec4 i2 = texture(TEXTURE, t2.xy);
	vec4 i3 = texture(TEXTURE, t3.xy);
	vec4 i4 = texture(TEXTURE, t4.xy);

	vec4 o1 = texture(TEXTURE, t5.xy);
	vec4 o3 = texture(TEXTURE, t6.xy);
	vec4 o2 = texture(TEXTURE, t5.zw);
	vec4 o4 = texture(TEXTURE, t6.zw);

	vec4 s1 = texture(TEXTURE, t1.zw);
	vec4 s2 = texture(TEXTURE, t2.zw);
	vec4 s3 = texture(TEXTURE, t3.zw);
	vec4 s4 = texture(TEXTURE, t4.zw);

	float ko1 = dot(abs(o1-c),dt);
	float ko2 = dot(abs(o2-c),dt);
	float ko3 = dot(abs(o3-c),dt);
	float ko4 = dot(abs(o4-c),dt);

	float k1=min(dot(abs(i1-i3),dt),max(ko1,ko3));
	float k2=min(dot(abs(i2-i4),dt),max(ko2,ko4));

	float w1 = k2; if(ko3<ko1) w1*=ko3/ko1;
	float w2 = k1; if(ko4<ko2) w2*=ko4/ko2;
	float w3 = k2; if(ko1<ko3) w3*=ko1/ko3;
	float w4 = k1; if(ko2<ko4) w4*=ko2/ko4;

	c=(w1*o1+w2*o2+w3*o3+w4*o4+0.001*c)/(w1+w2+w3+w4+0.001);
	w1 = k*dot(abs(i1-c)+abs(i3-c),dt)/(0.125*dot(i1+i3,dt)+lum_add);
	w2 = k*dot(abs(i2-c)+abs(i4-c),dt)/(0.125*dot(i2+i4,dt)+lum_add);
	w3 = k*dot(abs(s1-c)+abs(s3-c),dt)/(0.125*dot(s1+s3,dt)+lum_add);
	w4 = k*dot(abs(s2-c)+abs(s4-c),dt)/(0.125*dot(s2+s4,dt)+lum_add);

	w1 = clamp(w1+mx,min_w,max_w);
	w2 = clamp(w2+mx,min_w,max_w);
	w3 = clamp(w3+mx,min_w,max_w);
	w4 = clamp(w4+mx,min_w,max_w);

	color = vec4(w1*(i1+i3)+w2*(i2+i4)+w3*(s1+s3)+w4*(s2+s4)+c)/(2.0*(w1+w2+w3+w4)+1.0);
	COLOR = color; //texture(iChannel0, uv);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
