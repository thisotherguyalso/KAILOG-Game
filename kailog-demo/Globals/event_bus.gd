extends Node

## Inventory
signal inventory_changed(inventory : Array[Item])
signal item_removal_requested(slot_index : int)
signal item_move_requested(origin_slot_index, slot_index)

## Money
signal item_refilled(cost: float)
signal item_sold(cost: float)
signal money_changed(amount: float)
signal item_purchase_requested(cost: float, item: Item)
signal item_bought()

## Points
signal points_changed(amount: int)
signal flood_meter_changed(points: int)
signal add_log_entry(log_entry: LogEntry)

## Grocery List
signal grocery_list_updated(grocery_list : Array[GroceryEntry])

## Rounds
signal round_finished(end_label: String, round_stats : RoundStats)
signal round_timer_ticked(time_left : float)
