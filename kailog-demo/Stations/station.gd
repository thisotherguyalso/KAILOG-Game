class_name Station
extends Area2D

signal item_processed(item: Item)

const HOVER_SCALE := Vector2(1.1, 1.1)
const NORMAL_SCALE := Vector2(1.0, 1.0)
const TWEEN_DURATION := 0.15

@onready var progress_bar = $ProgressBar
var _hover_tween: Tween = null
var _is_hovered := false

@export var money_down_texture : Texture2D
@export var money_up_texture : Texture2D

## For mouse hovering
func _ready() -> void:
	mouse_entered.connect(func(): _tween_scale(HOVER_SCALE))
	mouse_exited.connect(func(): _tween_scale(NORMAL_SCALE))

func _tween_scale(target: Vector2) -> void:
	if _hover_tween:
		_hover_tween.kill()
	_hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_hover_tween.tween_property(self, "scale", target, TWEEN_DURATION)

## For the progress bar
func _show_progress(duration: float) -> void:
	progress_bar.max_value = duration
	progress_bar.value = 0.0
	progress_bar.show()
	var tween := create_tween()
	tween.tween_property(progress_bar, "value", duration, duration)
	tween.tween_callback(_hide_progress)

func _hide_progress() -> void:
	progress_bar.hide()

## For stations that need to spawn pickups
func _spawn_pickup(item: Item) -> void:
	var pickup := preload("res://Pickups/pickup.tscn").instantiate()
	pickup.item = item.duplicate()
	pickup.global_position = global_position + Vector2(randi_range(-50, 50), 40)
	get_parent().add_child(pickup)

## For stations that players can buy from, returns selling price of item
func _get_sell_price(item: Item) -> float:
	if item is ItemContainer:
		return item.get_sell_price()
	return 0.0

## Subclass methods
func can_receive(_item: Item) -> bool:
	return false

func receive_item(_item: Item) -> void:
	pass

func interact() -> void:
	pass

func spawn_particles(texture : Texture2D):
	var feedback_particle : FeedbackParticle = preload("res://UI/feedback_particle.tscn").instantiate()
	feedback_particle.set_particle_texture(texture)
	feedback_particle.position = Vector2(randf_range(-32.0, 32.0), randf_range(-32.0, 32.0))
	add_child(feedback_particle)
	feedback_particle.emit_feedback()
