## Accepts dirty containers, cleans them after a delay, and spews them out.
class_name CleaningStation
extends Station

@export var clean_duration: float = 3.0

var _is_busy := false

func can_receive(item: Item) -> bool:
	if _is_busy:
		return false
	return (item is ItemContainer
			and item.state != ItemContainer.ContainerState.CLEAN)

func receive_item(item: Item) -> void:
	_is_busy = true
	var container := item as ItemContainer
	
	$CleaningSFX.play(2.0)
	$AnimatedSprite2D.play("cleaning")
	
	_show_progress(clean_duration)
	await get_tree().create_timer(clean_duration).timeout
	
	$AnimatedSprite2D.play("default")
	$CleaningSFX.stop()
	container.clean()
	_spawn_pickup(container)
	_is_busy = false
	item_processed.emit(container)
