## Base class for all interactable stations.
##
## Node structure:
##   Station (Area2D)           ← this script (layer 4, mask 3)
##     ├─ Sprite2D
##     └─ CollisionShape2D
##
## PickupItem (Area2D) should be on layer 3 so stations detect it.
## Stations detect pickups via area_entered. For pickups that spawn
## already overlapping, PickupItem calls check_for_overlapping_pickups().
class_name Station
extends Area2D

signal item_processed(item: Item)

var _nearby_player: Player = null


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


# ── Pickup detection ─────────────────────────────────────────────────────────

## Fires when a pickup moves into the station after spawning elsewhere.
func _on_area_entered(area: Area2D) -> void:
	_try_consume(area)


## Called by PickupItem for the spawn-on-top case.
## Needs one physics frame for get_overlapping_areas() to populate.
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


## Called when the player clicks/taps the station without dragging.
func interact(_player: Player) -> void:
	pass


# ── Player proximity ─────────────────────────────────────────────────────────

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_nearby_player = body


func _on_body_exited(body: Node2D) -> void:
	if body is Player and body == _nearby_player:
		_nearby_player = null
