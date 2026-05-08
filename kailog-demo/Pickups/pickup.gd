class_name Pickup
extends Area2D

@export var item : Item

func _ready():
	item = item.duplicate()
	item._update_visuals()
	$Sprite2D.texture = item.icon
	self.scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)

func _on_body_entered(body):
	if body is Player:
		if not body.inventory.is_empty():
			return
		body.inventory.add_item(item)
		self.queue_free()
