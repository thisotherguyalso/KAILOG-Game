class_name RoundManager
extends Timer

## These are the variables needed to be initialized by LevelManager, outside of level
@export var money_component : MoneyComponent
@export var points_component : PointsComponent
@export var log_component : LogComponent

var initial_money : int
var initial_points : int
## Needs to be initialized in-level
@export var house_station : HouseStation

func _ready():
	initial_money = money_component.amount
	initial_points = points_component.points
	EventBus.flood_meter_changed.connect(check_flood)
	EventBus.grocery_list_updated.connect(check_groceries)
	await get_parent().ready
	await $"../CanvasLayer/Countdown".countdown_finished
	start_round()
	start()

func check_groceries(grocery_list : Array[GroceryEntry]):
	for grocery_entry in grocery_list:
		if grocery_entry.current_quantity < grocery_entry.needed_quantity:
			return
	finish_round("Groceries done!")

func check_flood(points):
	print(points)
	if points >= points_component.maximum:
		finish_round("It flooded!")

func _on_timeout():
	finish_round("Time's Up!")

func _process(_delta : float) -> void:
	EventBus.round_timer_ticked.emit(time_left)

func finish_round(end_label):
	if not is_stopped():
		stop()
	EventBus.round_finished.emit(end_label, create_round_results())

func create_round_results():
	var round_results = RoundResults.new()
	round_results.current_money = money_component.amount
	round_results.initial_money = initial_money
	round_results.initial_points = initial_points
	round_results.grocery_list = house_station.grocery_list.duplicate()
	round_results.log_list = log_component.log_entries.duplicate()
	return round_results

func start_round():
	$"../Player".movement.allow_movement()
