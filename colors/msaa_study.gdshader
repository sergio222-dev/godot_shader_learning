shader_type canvas_item;

uniform float mx : hint_range(-2.0, 2.0) = 1.00; // start smoothing wt.
uniform float k : hint_range(-2.0, 2.0) = -1.10; // wt. decrease factor
uniform float max_w : hint_range(-2.0, 2.0) = 0.75; // max filter weigth
uniform float min_w : hint_range(-2.0, 2.0) = 0.03; // min filter weigth
uniform float lum_add : hint_range(-2.0, 2.0) = 0.33; // effects smoothing

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	ivec2 texture_size = textureSize(TEXTURE, 0);
	vec4 c = color;

	float x = 0.5 * (1.0 / float(texture_size.x));
	float y = 0.5 * (1.0 / float(texture_size.y));

	const vec4 dt = 1.0*vec4(1.0, 1.0, 1.0, 1.0);

	vec2 dg1 = vec2( x, y); // abajo derecha
	vec2 dg2 = vec2(-x, y); // abajo izquierda

	vec2 sd1 = dg1*0.5; // abajo derecha mitad
	vec2 sd2 = dg2*0.5; // abajo izquierda mitad

	vec2 ddx = vec2(x,0.0); // derecha
	vec2 ddy = vec2(0.0,y); // abajo

	vec4 t1 = vec4(UV-sd1,UV-ddy); // sample arriba izquierda mitad y arriba
	vec4 t2 = vec4(UV-sd2,UV+ddx); // sample arriba derecha mitad y derecha
	vec4 t3 = vec4(UV+sd1,UV+ddy); // sample abajo derecha mitad y abajo
	vec4 t4 = vec4(UV+sd2,UV-ddx); // sample abajo izquierda mitad y izquierda
	vec4 t5 = vec4(UV-dg1,UV-dg2); // sample arriba izquierda y arriba derecha
	vec4 t6 = vec4(UV+dg1,UV+dg2); // sample abajo derecha y abajo izquierda

	vec4 i1 = texture(TEXTURE, t1.xy); // sample arriba izquierda mitad
	vec4 i2 = texture(TEXTURE, t2.xy); // sample arriba derecha mitad
	vec4 i3 = texture(TEXTURE, t3.xy); // sample abajo derecha mitad
	vec4 i4 = texture(TEXTURE, t4.xy); // sample abajo izquierda mitad

	vec4 o1 = texture(TEXTURE, t5.xy); // sample arriba izquierda
	vec4 o2 = texture(TEXTURE, t5.zw); // sample arriba derecha
	vec4 o3 = texture(TEXTURE, t6.xy); // sample abajo derecha
	vec4 o4 = texture(TEXTURE, t6.zw); // sample abajo izquierda

	vec4 s1 = texture(TEXTURE, t1.zw);
	vec4 s2 = texture(TEXTURE, t2.zw);
	vec4 s3 = texture(TEXTURE, t3.zw);
	vec4 s4 = texture(TEXTURE, t4.zw);

	// luminicencia diff
	float ko1 = dot(abs(o1-c),dt); // diferencia sample arriba izquierda con el actual
	float ko2 = dot(abs(o2-c),dt); // diferencia sample arriba derecha con el actual
	float ko3 = dot(abs(o3-c),dt); // diferencia sample abajo derecha con el actual
	float ko4 = dot(abs(o4-c),dt); // diferencia sample abajo izquierda con el actual

	/*
	i1 - i3 = diferencia sample arriba izquierda mitad y abajo derecha mitad
	*/
	float k1=min(dot(abs(i1-i3),dt),max(ko1,ko3)); 
	float k2=min(dot(abs(i2-i4),dt),max(ko2,ko4));

	float w1 = k2; if(ko3<ko1) w1*=ko3/ko1;
	float w2 = k1; if(ko4<ko2) w2*=ko4/ko2;
	float w3 = k2; if(ko1<ko3) w3*=ko1/ko3;
	float w4 = k1; if(ko2<ko4) w4*=ko2/ko4;
	
	//COLOR.rgb = w1*o1.rgb + w2*o2.rgb + w3*o3.rgb + w4*o4.rgb + 0.001*c.rgb/w1 + w2 + w3 + w4 + 0.001;

	c=(w1*o1+w2*o2+w3*o3+w4*o4+0.001*c)/(w1+w2+w3+w4+0.001);
	COLOR.rgb = (w1 * o1.rgb + w2*o2.rgb +0.001*c.rgb)/ (w1 + w2 + .001);
	w1 = k*dot(abs(i1-c)+abs(i3-c),dt)/(0.125*dot(i1+i3,dt)+lum_add);
	w2 = k*dot(abs(i2-c)+abs(i4-c),dt)/(0.125*dot(i2+i4,dt)+lum_add);
	w3 = k*dot(abs(s1-c)+abs(s3-c),dt)/(0.125*dot(s1+s3,dt)+lum_add);
	w4 = k*dot(abs(s2-c)+abs(s4-c),dt)/(0.125*dot(s2+s4,dt)+lum_add);

	w1 = clamp(w1+mx,min_w,max_w);
	w2 = clamp(w2+mx,min_w,max_w);
	w3 = clamp(w3+mx,min_w,max_w);
	w4 = clamp(w4+mx,min_w,max_w);

	color = vec4(w1*(i1+i3)+w2*(i2+i4)+w3*(s1+s3)+w4*(s2+s4)+c)/(2.0*(w1+w2+w3+w4)+1.0);
	//COLOR = color; //texture(iChannel0, uv);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
