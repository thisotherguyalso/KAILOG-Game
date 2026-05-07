class_name GroceryEntryResult
extends HBoxContainer

signal animation_finished

@onready var texture_rect: TextureRect = $TextureRect
@onready var current: Label = $Current
@onready var slash: Label = $Slash
@onready var maximum: Label = $Maximum
@onready var check: TextureRect = $Check
@onready var boop_sfx: AudioStreamPlayer = $BoopSFX
@onready var result_sfx: AudioStreamPlayer = $ResultSFX

const POP_DURATION := 0.1
const BOOP_STAGGER := 0.30
const CHECK_DELAY := 0.5
const CHECK_DURATION := 0.4

const YAY_IMG = preload("uid://bvfd6iq556yfo")
const AWW_IMG = preload("uid://bvfd6iq556yfo")
const SMALL_WIN = preload("uid://bwmaxw0t0yqbn")
const SMALL_LOSE = preload("uid://bwmaxw0t0yqbn")

func _ready():
	for node in [texture_rect, current, slash, maximum, check]:
		node.scale = Vector2.ZERO
		node.modulate.a = 0.0

func play_animation():
	await get_tree().process_frame
	_set_initial_states()
	_play_reveal_sequence()

func set_data(entry: GroceryEntry):
	texture_rect.texture = entry.texture
	current.text = str(entry.current_quantity)
	maximum.text = str(entry.needed_quantity)
	var won = entry.current_quantity >= entry.needed_quantity
	check.texture = YAY_IMG if won else AWW_IMG
	result_sfx.stream = SMALL_WIN if won else SMALL_LOSE

func _set_initial_states():
	for node in [texture_rect, current, slash, maximum, check]:
		node.pivot_offset = node.size / 2
		node.scale = Vector2.ZERO
		node.modulate.a = 1.0  # restore alpha now that pivot is set

func _play_reveal_sequence():
	var tween = create_tween()
	
	tween.tween_callback(_boop_in.bind(texture_rect))
	tween.tween_interval(BOOP_STAGGER)
	
	tween.tween_callback(_boop_in.bind(current))
	tween.tween_interval(BOOP_STAGGER)
	
	tween.tween_callback(_boop_in.bind(slash))
	tween.tween_interval(BOOP_STAGGER)
	
	tween.tween_callback(_boop_in.bind(maximum))
	tween.tween_interval(CHECK_DELAY)
	
	tween.tween_callback(_pop_check)
	tween.tween_interval(CHECK_DURATION)
	
	tween.tween_callback(func(): animation_finished.emit())

func _boop_in(node: Control):
	boop_sfx.play(0.15)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2.ONE, POP_DURATION)

func _pop_check():
	result_sfx.play()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(check, "scale", Vector2.ONE, CHECK_DURATION)
