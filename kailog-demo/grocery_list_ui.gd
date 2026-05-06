extends Button

@export var open_button: Button
var is_hidden = false

func _ready():
	EventBus.connect("grocery_list_updated", _on_grocery_list_updated)

func _on_grocery_list_updated(grocery_list : Array[GroceryEntry]):
	reset_container()
	for grocery_entry in grocery_list:
		create_grocery_entry(grocery_entry)

func reset_container():
	for child in $VFlowContainer.get_children():
		child.queue_free()

func create_grocery_entry(grocery_entry: GroceryEntry):
	var new_grocery_entry_ui : GroceryEntryUI = preload("res://UI/grocery_entry_ui.tscn").instantiate()
	new_grocery_entry_ui.contents = grocery_entry.content
	new_grocery_entry_ui.current = grocery_entry.current_quantity
	new_grocery_entry_ui.maximum = grocery_entry.needed_quantity
	new_grocery_entry_ui.texture = grocery_entry.texture
	$VFlowContainer.add_child(new_grocery_entry_ui)

func open_ui():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.08)

func close_ui():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.08)

func _on_pressed():
	close_ui()
	open_button.show()
