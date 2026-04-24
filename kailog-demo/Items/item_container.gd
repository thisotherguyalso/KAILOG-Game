class_name ItemContainer
extends Item

enum ContainerState {
	BOUGHT,
	CLEAN,
	DIRTY,
	REFILLED,
}

## The contents of the container. An empty string if nothing.
@export var contents: String = ""
## The state of the container.
@export var state: ContainerState = ContainerState.BOUGHT:
	set(value):
		state = value
		_update_visuals()

@export var sell_price_clean: float = 10.0
@export var sell_price_dirty: float = 5.0

## Per-state icons (shown in inventory). Falls back to base `icon` if not set.
@export_group("State Visuals")
@export var icon_bought_map: Dictionary[String, Texture2D] = {}
@export var icon_clean: Texture2D
@export var icon_dirty: Texture2D
@export var icon_refilled_map: Dictionary[String, Texture2D] = {}

## Per-state world sprites. Falls back to base `sprite` if not set.
@export var sprite_bought_map: Dictionary[String, Texture2D] = {}
@export var sprite_clean: Texture2D
@export var sprite_dirty: Texture2D
@export var sprite_refilled_map: Dictionary[String, Texture2D] = {}

# ── Visuals ──────────────────────────────────────────────────────────────────

func _update_visuals() -> void:
	icon = get_icon_for_state(state)
	sprite = get_sprite_for_state(state)


func get_icon_for_state(s: ContainerState) -> Texture2D:
	var tex: Texture2D = _state_icon(s)
	return tex if tex else icon


func get_sprite_for_state(s: ContainerState) -> Texture2D:
	var tex: Texture2D = _state_sprite(s)
	return tex if tex else sprite


func _state_sprite(s: ContainerState) -> Texture2D:
	match s:
		ContainerState.BOUGHT:   return sprite_bought_map.get(contents, null)
		ContainerState.CLEAN:    return sprite_clean
		ContainerState.DIRTY:    return sprite_dirty
		ContainerState.REFILLED: return sprite_refilled_map.get(contents, null)
	return null

func _state_icon(s: ContainerState) -> Texture2D:
	match s:
		ContainerState.BOUGHT:   return icon_bought_map.get(contents, null)
		ContainerState.CLEAN:    return icon_clean
		ContainerState.DIRTY:    return icon_dirty
		ContainerState.REFILLED: return icon_refilled_map.get(contents, null)
	return null


# ── Price ────────────────────────────────────────────────────────────────────

func get_sell_price() -> float:
	match state:
		ContainerState.CLEAN, ContainerState.BOUGHT, ContainerState.REFILLED:
			return sell_price_clean
		ContainerState.DIRTY:
			return sell_price_dirty
	return 0.0


# ── State changes ────────────────────────────────────────────────────────────

func clean() -> void:
	state = ContainerState.CLEAN


func refill(new_contents: String) -> void:
	if state == ContainerState.CLEAN:
		contents = new_contents
		state = ContainerState.REFILLED
