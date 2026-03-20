extends Area2D

@export var item: Item

func _on_body_entered(body: Player) -> void:
	print("Trash Collected")
	queue_free()
