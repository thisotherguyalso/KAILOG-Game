extends Area2D

@export var item: Item

func _ready():
	$Sprite2D.texture = item.sprite
	

## TODO: Give the player the item resource
## TODO: Don't immediately give it. there should be a button that allows the player to chooose if theyre gonna get it or not
func _on_body_entered(body: Player) -> void:
	if body.inventory.add_item(item):
		print("Trash Collected")
		queue_free()
