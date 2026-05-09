## Place to bring items back home
## - Drop an item onto it → fulfill grocery list.
class_name HouseStation
extends Station

## Grocery List
@export var grocery_list : Array[GroceryEntry]

## Points
@export var points_refilled : int = -4
@export var points_bought : int = 2

## Particle_Textures:
@export var particle_texture : Texture2D

func _ready() -> void:
	super._ready()
	EventBus.grocery_list_updated.emit(grocery_list)

## Receiving items
func can_receive(item: Item) -> bool:
	return check_if_bringable(item)

func check_if_bringable(item: Item) -> bool:
	var container = item as ItemContainer
	var contents = container.contents
	var grocery_entry = find_grocery_entry(contents)
	
	if !grocery_entry:
		return false
	
	return false if \
	grocery_entry.needed_quantity == grocery_entry.current_quantity \
	else true

func find_grocery_entry(contents : String) -> GroceryEntry:
	for grocery_entry in grocery_list:
		if grocery_entry.content == contents:
			return grocery_entry
	return null

func receive_item(item: Item) -> void:
	var container = item as ItemContainer
	var contents = container.contents
	var grocery_entry = find_grocery_entry(contents)
	var points = check_points(item)
	EventBus.points_changed.emit(points)
	EventBus.add_log_entry.emit(new_log_entry(parse_description(item), points))
	add_grocery(grocery_entry)
	spawn_particles(particle_texture)
	$WinSFX.play()
	# TODO: show floating "+Points" feedback.

func add_grocery(grocery_entry: GroceryEntry):
	grocery_entry.current_quantity += 1
	EventBus.grocery_list_updated.emit(grocery_list)

func check_points(item : Item) -> int:
	var container = item as ItemContainer
	if container.state == container.ContainerState.BOUGHT:
		return points_bought
	elif container.state == container.ContainerState.REFILLED:
		return points_refilled
	return 0

func parse_description(item: Item) -> String:
	var container = item as ItemContainer
	var container_state : String = container.ContainerState.keys()[container.state]
	if container.contents:
		var container_content : String = container.contents
		return "Brought Home " + container_state.capitalize() + " " + container_content + " " + item.item_name
	else:
		return "Brought Home " + container_state.capitalize() + " " + item.item_name
	return ""

func new_log_entry(desc : String, points: int) -> LogEntry:
	var new_le = LogEntry.new()
	new_le.description = desc
	new_le.points = points
	return new_le
