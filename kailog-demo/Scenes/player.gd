extends CharacterBody2D

@export var moveSpeed = 300.0
@export var isSprinting = false


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * moveSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.y = move_toward(velocity.y, 0, moveSpeed)
		
	if Input.get_action_strength("sprint"):
		velocity = direction * moveSpeed * 2
		isSprinting = true
	else:
		velocity = direction * moveSpeed
		isSprinting = false

	move_and_slide()
