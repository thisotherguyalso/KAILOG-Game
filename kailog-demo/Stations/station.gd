## Base class for all interactable stations.
##
## Node structure:
##   Station (Area2D)           ← this script
##     ├─ Sprite2D
##     └─ CollisionShape2D
##
## Add the Player node to the "Player" group in the editor.
class_name Station
extends Area2D

signal item_processed(item: Item)

const HOVER_SCALE := Vector2(1.1, 1.1)
const NORMAL_SCALE := Vector2(1.0, 1.0)
const TWEEN_DURATION := 0.15

var _player_cache: Player = null
var player: Player:
	get:
		if _player_cache == null:
			_player_cache = get_tree().get_first_node_in_group("Player")
		return _player_cache

var _hover_tween: Tween = null
var _progress_bar: ProgressBar = null


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


# ── Hover tween ──────────────────────────────────────────────────────────────

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_item"):
		_tween_scale(HOVER_SCALE)
		_try_consume(area)
	

func _on_area_exited(area: Area2D) -> void:
	if area.has_method("get_item"):
		_tween_scale(NORMAL_SCALE)


func _tween_scale(target: Vector2) -> void:
	if _hover_tween:
		_hover_tween.kill()
	_hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_hover_tween.tween_property(self, "scale", target, TWEEN_DURATION)


# ── Progress bar ─────────────────────────────────────────────────────────────

func _show_progress(duration: float) -> void:
	_progress_bar = ProgressBar.new()
	_progress_bar.max_value = duration
	_progress_bar.value = 0.0
	_progress_bar.show_percentage = false
	_progress_bar.custom_minimum_size = Vector2(80, 10)
	_progress_bar.position = Vector2(-40, -50)
	add_child(_progress_bar)

	var tween := create_tween()
	tween.tween_property(_progress_bar, "value", duration, duration)
	tween.tween_callback(_hide_progress)


func _hide_progress() -> void:
	if _progress_bar:
		_progress_bar.queue_free()
		_progress_bar = null


# ── Pickup detection ─────────────────────────────────────────────────────────

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
	if player == null:
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
