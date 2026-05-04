## Combined buy/sell station.
## - Click/tap → buys the configured item and spawns it as a pickup.
## - Drop an item onto it → sells it for money.
class_name ShopStation
extends Station

@export var item_for_sale: Item
@export var buy_price: float = 15.0

func _ready() -> void:
	super._ready()
	EventBus.item_bought.connect(_on_item_bought)

# ── Selling (pickup lands on station) ────────────────────────────────────────

func can_receive(item: Item) -> bool:
	return _get_sell_price(item) > 0.0

func receive_item(item: Item) -> void:
	var price := _get_sell_price(item)
	EventBus.item_sold.emit(price)
	$MoneySFX.play(0.50)
	# TODO: show floating "+$X" feedback.

# ── Buying (click) ───────────────────────────────────────────────────────────

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		interact()
	elif event is InputEventScreenTouch and event.pressed:
		interact()

func interact() -> void:
	if item_for_sale == null:
		return
	EventBus.item_purchase_requested.emit(buy_price)

func _on_item_bought():
	_spawn_pickup(item_for_sale)
