class_name ItemContainer extends Item

enum ContainerState {
	BOUGHT,
	CLEAN,
	DIRTY,
	REFILLED
}

## The contents of the container. An empty string if nothing.
@export var contents: String = ""
## The state of the container. 
@export var state: ContainerState = ContainerState.BOUGHT
## The selling price when the container is clean
@export var sell_price_clean: float = 10.0
## The selling price when the container is dirty
@export var sell_price_dirty: float = 5.0

## Returns the selling price of the container based on the state.
func get_sell_price() -> float:
	match state:
		ContainerState.CLEAN, ContainerState.BOUGHT, ContainerState.REFILLED:
			return sell_price_clean
		ContainerState.DIRTY:
			return sell_price_dirty
		_:
			return 0.0

## Changes the state of the container to clean.
func clean() -> void:
	state = ContainerState.CLEAN

## Changes the contents of the container.
func refill(new_contents: String) -> void:
	if state == ContainerState.CLEAN:
		contents = new_contents
		state = ContainerState.REFILLED
