class_name PickupItem extends Area2D

@export var item: Item

func _ready():
	if item is ItemContainer:
		item._update_visuals()
	$Sprite2D.texture = item.sprite
	_notify_nearby_stations()

## TODO: Don't immediately give it. there should be a button that allows the player to chooose if theyre gonna get it or not
func _on_body_entered(body: Player) -> void:
	if body.inventory.add_item(item):
		print("Trash Collected")
		queue_free()

func get_item() -> Item:
	return item

func _notify_nearby_stations() -> void:
	await get_tree().physics_frame
	for area in get_overlapping_areas():
		if area is Station:
			area.check_for_overlapping_pickups()
