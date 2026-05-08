class_name MoneyResults
extends Control

const SMALL_WIN = preload("uid://bwmaxw0t0yqbn")
const SMALL_LOSE = preload("uid://bwmaxw0t0yqbn")

const WIN_COLOR := Color("6ee7a8")
const LOSE_COLOR := Color("ff7a8a")

const POP_DURATION := 0.1
const BOOP_STAGGER := 0.30
const CURRENT_DELAY := 0.5
const CURRENT_DURATION := 0.4

@onready var initial: Label = $Initial
@onready var to: Label = $To
@onready var current: Label = $Current
@onready var boop_sfx: AudioStreamPlayer = $BoopSFX
@onready var result_sfx: AudioStreamPlayer = $ResultSFX

var initial_money: int = 0
var current_money: int = 0

func _ready():
	hide()
	for node in [initial, to, current]:
		node.scale = Vector2.ZERO

func set_data(starting: int, ending: int):
	initial_money = starting
	current_money = ending
	
	var won = current_money >= initial_money
	var arrow = "↑" if won else "↓"
	
	initial.text = "₱%d" % initial_money
	current.text = "₱%d %s" % [current_money, arrow]
	
	current.modulate = WIN_COLOR if won else LOSE_COLOR
	result_sfx.stream = SMALL_WIN if won else SMALL_LOSE

func play():
	show()
	await get_tree().process_frame
	_set_pivots()
	await _play_reveal_sequence()

func _set_pivots():
	for node in [initial, to, current]:
		node.pivot_offset = node.size / 2

func _play_reveal_sequence():
	var tween = create_tween()
	
	tween.tween_callback(_boop_in.bind(initial))
	tween.tween_interval(BOOP_STAGGER)
	
	tween.tween_callback(_boop_in.bind(to))
	tween.tween_interval(CURRENT_DELAY)
	
	tween.tween_callback(_pop_current)
	tween.tween_interval(CURRENT_DURATION)
	
	await tween.finished

func _boop_in(node: Control):
	boop_sfx.play()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2.ONE, POP_DURATION)

func _pop_current():
	result_sfx.play()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(current, "scale", Vector2.ONE, CURRENT_DURATION)
