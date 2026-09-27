shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;
uniform float cell_size: hint_range(5.0, 20.0) = 10.0;
uniform float compensate: hint_range(0.0, 0.8) = 0.25;
uniform float soft: hint_range(0.01, 0.5) = 0.1;

const vec3 CENTRES = vec3(0.5, 1.5, 2.5);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 cell = floor(FRAGCOORD.xy / cell_size);
	vec2 local = fract(FRAGCOORD.xy / cell_size);
	float stripe = local.x * 3.0; // r, g, b
	
	vec4 base = texture(screen_texture, SCREEN_UV, 1.0);
	base += (UV.x - 0.5) * (UV.x - 0.5);
	vec4 color;
	
	float k = compensate;
	vec3 d = stripe - CENTRES;
	d = abs(mod(d + 1.5, 3.0) - 1.5);
	vec3 m = 1.0 - smoothstep(0.5 - soft, 0.5 + soft, d);
	vec3 mask = mix(vec3(k), vec3(1.0), m);
	
	color = base * vec4(mask, 1);
	color *= 3.0 / (1.0 + 2.0 * k);
	
	COLOR = color;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
