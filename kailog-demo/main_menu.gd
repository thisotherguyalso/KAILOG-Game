class_name MainMenu
extends Control

@export var game_scene: PackedScene

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var quit_button: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play)
	quit_button.pressed.connect(_on_quit)
	_style_buttons()


func _style_buttons() -> void:
	# Play button — solid green pill
	var play_normal := StyleBoxFlat.new()
	play_normal.bg_color = Color("#2d9e60")
	play_normal.corner_radius_top_left = 40
	play_normal.corner_radius_top_right = 40
	play_normal.corner_radius_bottom_left = 40
	play_normal.corner_radius_bottom_right = 40
	play_normal.shadow_color = Color("#1a6e3f")
	play_normal.shadow_size = 4
	play_normal.shadow_offset = Vector2(0, 4)
	play_button.add_theme_stylebox_override("normal", play_normal)

	var play_pressed := play_normal.duplicate()
	play_pressed.shadow_size = 1
	play_pressed.shadow_offset = Vector2(0, 1)
	play_button.add_theme_stylebox_override("pressed", play_pressed)
	play_button.add_theme_color_override("font_color", Color.WHITE)
	play_button.add_theme_font_size_override("font_size", 20)

	# Quit button — ghost pill
	var quit_normal := StyleBoxFlat.new()
	quit_normal.bg_color = Color(1, 1, 1, 0.5)
	quit_normal.border_color = Color("#2d9e60", 0.5)
	quit_normal.border_width_top = 2
	quit_normal.border_width_bottom = 2
	quit_normal.border_width_left = 2
	quit_normal.border_width_right = 2
	quit_normal.corner_radius_top_left = 40
	quit_normal.corner_radius_top_right = 40
	quit_normal.corner_radius_bottom_left = 40
	quit_normal.corner_radius_bottom_right = 40
	quit_button.add_theme_stylebox_override("normal", quit_normal)
	quit_button.add_theme_color_override("font_color", Color("#1a5c3a"))
	quit_button.add_theme_font_size_override("font_size", 15)


func _on_play() -> void:
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)
	else:
		push_error("MainMenu: game_scene not assigned")


func _on_quit() -> void:
	get_tree().quit()
