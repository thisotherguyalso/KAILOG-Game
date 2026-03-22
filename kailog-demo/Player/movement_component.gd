class_name MovementComponent extends Node

@export var walkSpeed: float = 300.0
@export var sprintSpeed: float = 600.0
@export_range(0.0, 20.0) var slipperiness: float = 14.0
var isSprinting: bool = false
var speed: float = 0.0
var player: Player

func _ready():
	player = owner

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var velocity = Vector2.ZERO
	velocity.x = Input.get_axis("ui_left", "ui_right")
	velocity.y = Input.get_axis("ui_up", "ui_down")
	
	if velocity and !$"../WalkingSFX".playing:
		$"../WalkingSFX".play()
	elif not velocity:
		$"../WalkingSFX".stop()
	
	if velocity.x < 0:
		$"../Sprite2D".play('left')
	elif velocity.x > 0:
		$"../Sprite2D".play('right')
	elif velocity.y < 0:
		$"../Sprite2D".play('up')
	elif velocity.y > 0:
		$"../Sprite2D".play('down')
	else:
		$"../Sprite2D".play('idle')

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		player.velocity = lerp(player.velocity, direction * speed, delta * slipperiness) 
	else:
		player.velocity = lerp(player.velocity, Vector2.ZERO, delta * slipperiness) 
		
	if Input.get_action_strength("sprint"):
		speed = sprintSpeed
		isSprinting = true
	else:
		speed = walkSpeed
		isSprinting = false
	
	player.move_and_slide()
