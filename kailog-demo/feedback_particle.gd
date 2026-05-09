class_name FeedbackParticle
extends GPUParticles2D

var particle_texture : Texture2D

func _ready():
	one_shot = true
	$GPUParticles2D.one_shot = true

func emit_feedback() -> void:
	emitting = true
	$GPUParticles2D.emitting = true
	await finished
	queue_free()

func set_particle_texture(tex: Texture2D) -> void:
	texture = tex
	$GPUParticles2D.texture = tex
