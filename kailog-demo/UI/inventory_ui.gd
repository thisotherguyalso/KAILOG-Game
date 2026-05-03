extends Control

@onready var inventory_slots : Array = [
	$HBoxContainer/InventorySlot1,
	$HBoxContainer/InventorySlot2,
	$HBoxContainer/InventorySlot3,
	$HBoxContainer/InventorySlot4,
	$HBoxContainer/InventorySlot5
]

func _ready():
	EventBus.connect("inventory_changed", _on_inventory_changed)

func _on_inventory_changed(inventory : Array[Item]):
	for i in range(inventory.size()):
		if not inventory[i]:
			remove_item(i)
			continue
		add_item(i, inventory)

func remove_item(index):
	inventory_slots[index].item = null
	inventory_slots[index].icon.texture = null
	inventory_slots[index].is_empty = true
	inventory_slots[index].icon.hide()

func add_item(index, inventory):
	inventory_slots[index].item = inventory[index]
	inventory_slots[index].icon.texture = inventory[index].icon
	inventory_slots[index].is_empty = false
	inventory_slots[index].icon.show()
