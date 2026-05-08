class_name LogEntryResult
extends Control

signal animation_finished

const SMALL_WIN = preload("uid://bwmaxw0t0yqbn")
const SMALL_LOSE = preload("uid://bwmaxw0t0yqbn")

const WIN_COLOR := Color("6ee7a8")
const LOSE_COLOR := Color("ff7a8a")

const POP_DURATION := 0.6
const STAGGER := 0.5

@onready var description: Label = $Description
@onready var points: Label = $Points
@onready var boop_sfx: AudioStreamPlayer = $BoopSFX
@onready var result_sfx: AudioStreamPlayer = $ResultSFX

func _ready():
	for node in [description, points]:
		node.modulate.a = 0.0
		node.scale = Vector2.ZERO

func set_data(entry: LogEntry):
	description.text = entry.description
	
	var decreased_flood = entry.points <= 0
	var arrow = "↓" if decreased_flood else "↑"
	points.text = "%d %s" % [entry.points, arrow]
	
	points.modulate = WIN_COLOR if decreased_flood else LOSE_COLOR
	result_sfx.stream = SMALL_WIN if decreased_flood else SMALL_LOSE

func play_animation():
	await get_tree().process_frame
	_set_pivots()
	for node in [description, points]:
		node.modulate.a = 1.0
	await _play_reveal_sequence()
	animation_finished.emit()

func _set_pivots():
	for node in [description, points]:
		node.pivot_offset = node.size / 2

func _play_reveal_sequence():
	var tween = create_tween()
	
	tween.tween_callback(_boop_in.bind(description))
	tween.tween_interval(STAGGER)
	
	tween.tween_callback(_pop_points)
	tween.tween_interval(POP_DURATION)
	
	await tween.finished

func _boop_in(node: Control):
	boop_sfx.play()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2.ONE, POP_DURATION)

func _pop_points():
	result_sfx.play()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(points, "scale", Vector2.ONE, POP_DURATION)
