## Base class for all interactable stations.
##
## Node structure:
##   Station (Area2D)           ← this script
##     ├─ Sprite2D
##     └─ CollisionShape2D
##
## Add the Player node to the "player" group in the editor.
class_name Station
extends Area2D

signal item_processed(item: Item)

var _player_cache: Player = null
var player: Player:
	get:
		if _player_cache == null:
			_player_cache = get_tree().get_first_node_in_group("Player")
		return _player_cache


func _ready() -> void:
	area_entered.connect(_on_area_entered)


# ── Pickup detection ─────────────────────────────────────────────────────────

func _on_area_entered(area: Area2D) -> void:
	_try_consume(area)


func check_for_overlapping_pickups() -> void:
	await get_tree().physics_frame
	for area in get_overlapping_areas():
		if _try_consume(area):
			return


func _try_consume(area: Area2D) -> bool:
	if not is_instance_valid(area):
		return false
	if not area.has_method("get_item"):
		return false
	var item: Item = area.get_item()
	if item == null or not can_receive(item):
		return false
	area.queue_free()
	receive_item(item)
	return true


# ── Virtual methods (override in subclasses) ─────────────────────────────────

func can_receive(_item: Item) -> bool:
	return false


func receive_item(_item: Item) -> void:
	pass


func interact() -> void:
	pass
