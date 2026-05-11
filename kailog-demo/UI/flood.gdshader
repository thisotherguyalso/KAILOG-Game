shader_type canvas_item;

uniform float frequency : hint_range(0.01, 1.0) = 0.05;
uniform float amplitude : hint_range(0.0, 50.0) = 10.0;
uniform float speed : hint_range(0.0, 10.0) = 1.0;

void vertex() {
	float wave_mask = 1.0 - UV.y;
	VERTEX.y += sin(VERTEX.x * frequency + TIME * speed) * amplitude * wave_mask;
}

void fragment() {
	// Called for every pixel the material is visible on.
}