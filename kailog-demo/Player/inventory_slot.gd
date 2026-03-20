class_name InventorySlot
extends Control

var item: Item = null

func is_hovered(pos: Vector2) -> bool:
	return Rect2(global_position, size).has_point(pos)

func set_item(new_item: Item) -> void:
	item = new_item
	_rebuild_icon()

func _gui_input(event: InputEvent) -> void:
	var pressed := false
	var pos := Vector2.ZERO

	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
		pos = event.global_position
	elif event is InputEventScreenTouch:
		pressed = event.pressed
		pos = event.position

	if pressed:
		get_parent().start_drag(self, pos)

func _rebuild_icon() -> void:
	for child in get_children():
		child.queue_free()
	if item != null:
		var tex_rect := TextureRect.new()
		tex_rect.texture = item.icon
		tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(tex_rect)
