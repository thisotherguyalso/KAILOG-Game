## Accepts dirty containers, cleans them after a delay, and spews them out.
class_name CleaningStation
extends Station

@export var clean_duration: float = 3.0

var _is_busy := false


func can_receive(item: Item) -> bool:
	if _is_busy:
		return false
	return item is ItemContainer and item.state == ItemContainer.ContainerState.DIRTY


func receive_item(item: Item) -> void:
	_is_busy = true
	var container := item as ItemContainer

	# TODO: play cleaning animation / particles.
	await get_tree().create_timer(clean_duration).timeout

	container.clean()
	_spawn_pickup(container)
	_is_busy = false
	item_processed.emit(container)


func _spawn_pickup(item: Item) -> void:
	var pickup := preload("res://Items/pickup_item.tscn").instantiate()
	pickup.item = item
	pickup.global_position = global_position + Vector2(0, 40)
	get_parent().add_child(pickup)
