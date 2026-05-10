extends Button

func _on_button_down():
	Input.action_press("sprint")


func _on_button_up():
	Input.action_release("sprint")
