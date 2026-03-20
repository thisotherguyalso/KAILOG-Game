extends CharacterBody2D

@export var walkSpeed: float = 300.0
@export var sprintSpeed: float = 600.0
@export_range(0.0, 20.0) var slipperiness: float = 14.0
var isSprinting: bool = false
var speed: float = 0.0

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = lerp(velocity, direction * speed, delta * slipperiness) 
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta * slipperiness) 
		
	if Input.get_action_strength("sprint"):
		speed = sprintSpeed
		isSprinting = true
	else:
		speed = walkSpeed
		isSprinting = false
	
	move_and_slide()
