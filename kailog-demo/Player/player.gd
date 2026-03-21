class_name Player extends CharacterBody2D

@onready var movement: MovementComponent = $MovementComponent
@onready var inventory: InventoryComponent = $InventoryComponent
@onready var ui: PlayerUI = $"CanvasLayer/Player UI"
@export var game_manager: GameManager
