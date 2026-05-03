class_name Pickup
extends Area2D

@export var item : Item

func _on_body_entered(body):
	if body is Player:
		print("woah")
		body.inventory.add_item(item)
		self.queue_free()
