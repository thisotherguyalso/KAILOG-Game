class_name InventoryGrid extends HBoxContainer

func refresh_inventory(items: Array[Item]) -> void:
	var slots = get_children()
	for i in slots.size():
		# clear slot first
		for child in slots[i].get_children():
			child.queue_free()
		# fill if item exists
		if i < items.size():
			var tex_rect = TextureRect.new()
			tex_rect.texture = items[i].icon
			slots[i].add_child(tex_rect)
