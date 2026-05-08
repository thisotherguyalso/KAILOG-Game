extends Control

@onready var background = $Background
@onready var end_label: Label = $EndLabel
@onready var prompt_label: Label = $PromptLabel

@export var round_evaluation_scene: PackedScene

var awaiting_input: bool = false
var round_results : RoundResults

func _ready():
	hide()
	prompt_label.hide()
	EventBus.round_finished.connect(_on_round_finished)

func _on_round_finished(label_text: String, round_results : RoundResults):
	self.round_results = round_results
	show()
	_animate_background_in()
	_set_end_label(label_text)
	_animate_end_label_in()
	_show_prompt_after_delay()

func _animate_background_in():
	background.self_modulate.a = 0.0
	background.show()
	var tween = create_tween()
	tween.tween_property(background, "self_modulate:a", 0.5, 0.4)

func _set_end_label(label_text: String):
	end_label.text = label_text

func _animate_end_label_in():
	end_label.scale = Vector2.ZERO
	end_label.show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(end_label, "scale", Vector2.ONE, 0.4).set_delay(0.3)

func _show_prompt_after_delay():
	prompt_label.text = "Tap to continue"
	prompt_label.modulate.a = 0.0
	prompt_label.show()
	var tween = create_tween()
	tween.tween_property(prompt_label, "modulate:a", 1.0, 0.3).set_delay(0.9)
	tween.tween_callback(func(): awaiting_input = true)
	_pulse_prompt()

func _pulse_prompt():
	var tween = create_tween().set_loops()
	tween.tween_property(prompt_label, "modulate:a", 0.4, 0.6)
	tween.tween_property(prompt_label, "modulate:a", 1.0, 0.6)

func _input(event: InputEvent):
	if not awaiting_input:
		return
	var pressed = (event is InputEventMouseButton and event.pressed) \
		or (event is InputEventScreenTouch and event.pressed)
	if pressed:
		awaiting_input = false
		_spawn_evaluation_screen()

func _spawn_evaluation_screen():
	var eval : RoundEvaluation = round_evaluation_scene.instantiate()
	add_child(eval)
	eval.end_label.text = end_label.text
	eval.round_results = self.round_results
	eval.run_sequence()
