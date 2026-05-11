class_name MainMenu
extends Control

@export var game_scene: PackedScene

func _on_button_button_up():
	get_tree().change_scene_to_packed(game_scene)
