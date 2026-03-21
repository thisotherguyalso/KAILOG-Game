## Refills a clean container with this station's contents.
## Deducts refill_price from the player's money.
class_name RefillStation
extends Station

@export var fill_contents: String = ""
## Only accept containers whose item_name matches this. Leave empty for any.
@export var required_container_name: String = ""
@export var refill_duration: float = 2.0
@export var refill_price: float = 5.0

var _is_busy := false


func can_receive(item: Item) -> bool:
	if _is_busy:
		return false
	if not item is ItemContainer:
		return false
	var container := item as ItemContainer
	if container.state != ItemContainer.ContainerState.CLEAN:
		return false
	if (required_container_name != ""
			and container.item_name != required_container_name):
		return false
	return true


func receive_item(item: Item) -> void:
	player.money.deduct(refill_price)

	_is_busy = true
	var container := item as ItemContainer

	_show_progress(refill_duration)
	await get_tree().create_timer(refill_duration).timeout

	container.refill(fill_contents)
	_spawn_pickup(container)
	_is_busy = false
	item_processed.emit(container)


func _spawn_pickup(item: Item) -> void:
	var pickup := preload("res://Items/pickup_item.tscn").instantiate()
	pickup.item = item
	pickup.global_position = global_position + Vector2(randi_range(-100, 100), randi_range(-100, 100))
	get_parent().add_child(pickup)
