class_name InventorySlot
extends Panel

@onready var icon = $Icon
var item : Item
var is_empty : bool = true

@export var slot_index: int

func _ready():
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not is_empty:
				_spawn_floating_item()

func _spawn_floating_item():
	var floating_item : FloatingItem = preload("res://FloatingItem/floating_item.tscn").instantiate()
	floating_item.item = item
	floating_item.origin_slot_index = slot_index
	floating_item.drag_cancelled.connect(_on_drag_cancelled)
	get_tree().root.add_child(floating_item)
	floating_item.global_position = get_global_mouse_position()
	$Icon.hide()

func _on_drag_cancelled(_index: int) -> void:
	$"../../DragCancelledSFX".play()
	$Icon.show()
