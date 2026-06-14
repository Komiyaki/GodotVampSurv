extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)
		velocity.y = move_toward(velocity.y, 0, 20)
	move_and_slide()
