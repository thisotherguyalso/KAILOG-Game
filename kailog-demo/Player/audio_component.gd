extends Node

func _on_inventory_component_item_added(inventory):
	$PickupSFX.play()
