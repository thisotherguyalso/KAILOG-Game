## Refills a clean container with this station's contents.
## Deducts refill_price from the player's money.
class_name RefillStation
extends Station

@export var fill_contents: String = ""
## Only accept containers whose item_name matches this. Leave empty for any.
@export var required_container_name: Array[String]
@export var refill_duration: float = 2.0
@export var refill_price: float = 5.0

var _is_busy := false

@export var particle_texture : Texture2D

func can_receive(item: Item) -> bool:
	if _is_busy:
		return false
	if not item is ItemContainer:
		return false
	var container := item as ItemContainer
	if container.state != ItemContainer.ContainerState.CLEAN:
		return false
	if (container.item_name not in required_container_name):
		return false
	return true

func receive_item(item: Item) -> void:
	_is_busy = true
	var container := item as ItemContainer
	
	EventBus.item_refilled.emit(refill_price)
	$PouringSFX.play(0.2)
	$AnimatedSprite2D.play("refilling")
	$MoneySFX.play(0.5)
	spawn_particles(money_down_texture)
	
	_show_progress(refill_duration)
	await get_tree().create_timer(refill_duration).timeout
	
	$FinishedSFX.play()
	$PouringSFX.stop()
	$AnimatedSprite2D.play("default")
	spawn_particles(particle_texture)

	container.refill(fill_contents)
	_spawn_pickup(container)
	_is_busy = false
	item_processed.emit(container)
