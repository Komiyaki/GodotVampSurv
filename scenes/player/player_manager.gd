extends CharacterBody2D

@onready var stat_comp: stats = $stats
@onready var health_comp: health = $health
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var friction: int = 400

func _ready() -> void:
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	
	if direction != Vector2.ZERO:
		if direction.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
		velocity = direction * stat_comp.get_stat(stats.MOVE_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")
	move_and_slide()
