class_name Player extends CharacterBody2D

@onready var movement: MovementComponent = $MovementComponent
@onready var inventory: InventoryComponent = $InventoryComponent

func _ready():
	print("Player groups: ", get_groups())
