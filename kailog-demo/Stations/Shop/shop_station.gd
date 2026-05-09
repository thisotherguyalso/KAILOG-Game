## Combined buy/sell station.
## - Click/tap → buys the configured item and spawns it as a pickup.
## - Drop an item onto it → sells it for money.
class_name ShopStation
extends Station

@export var item_for_sale: Item
@export var buy_price: float = 15.0
@export var points_sold: int = -10
@export var points_bought: int = +25

func _ready() -> void:
	super._ready()
	EventBus.item_bought.connect(_on_item_bought)

# ── Selling (pickup lands on station) ────────────────────────────────────────

func can_receive(item: Item) -> bool:
	var container = item as ItemContainer
	if container.state == container.ContainerState.DIRTY:
		return false
	return _get_sell_price(item) > 0.0

func receive_item(item: Item) -> void:
	var price := _get_sell_price(item)
	EventBus.item_sold.emit(price)
	EventBus.points_changed.emit(points_sold)
	EventBus.add_log_entry.emit(new_log_entry(parse_description(item), points_sold))
	spawn_particles(money_up_texture)
	$MoneySFX.play(0.50)
	# TODO: show floating "+$X" feedback.

func parse_description(item: Item) -> String:
	var container = item as ItemContainer
	var container_state : String = container.ContainerState.keys()[container.state]
	if container.contents:
		var container_content : String = container.contents
		return "Sold " + container_state.capitalize() + " " + container_content + " " + item.item_name
	else:
		return "Sold " + container_state.capitalize() + " " + item.item_name
	return ""

func new_log_entry(desc : String, points: int) -> LogEntry:
	var new_le = LogEntry.new()
	new_le.description = desc
	new_le.points = points
	return new_le

# ── Buying (click) ───────────────────────────────────────────────────────────

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		interact()
	elif event is InputEventScreenTouch and event.pressed:
		interact()

func interact() -> void:
	if item_for_sale == null:
		return
	$MoneySFX.play(0.58)
	spawn_particles(money_down_texture)
	EventBus.item_purchase_requested.emit(buy_price)
	var description = "Bought " + item_for_sale.item_name
	EventBus.add_log_entry.emit(new_log_entry(description, points_bought))

func _on_item_bought():
	_spawn_pickup(item_for_sale)
