shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, UV); // Read from texture

	float t = mod(TIME, 4.0) - 1.0;
	
	float stepper1 = (UV.x + t) + (UV.y + t*1.2) * 2.0f;
	float shine = smoothstep(0.15, 0.35, stepper1);

	t = t - 0.07;
	float stepper2 = (UV.x + t ) + (UV.y + t*1.2) * 2.0f;
	float shine2 = smoothstep(0.15, 0.35, stepper2);
	
	float s = shine * (1.0 - shine2);
	
	COLOR.rgb = COLOR.rgb + 0.8 * vec3(s);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
