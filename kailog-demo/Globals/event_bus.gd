extends Node

signal inventory_changed(inventory : Array[Item])
signal item_removed(slot_index : int)
signal item_move_requested(origin_slot_index, slot_index)
