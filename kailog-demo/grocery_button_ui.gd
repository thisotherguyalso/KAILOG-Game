extends Button

@export var grocery_list_ui: Control

func _on_pressed():
	grocery_list_ui.open_ui()
	hide()
