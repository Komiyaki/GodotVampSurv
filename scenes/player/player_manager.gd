extends CharacterBody2D

@onready var stat_comp: stats = $stats
@onready var health_comp: health = $health

@export var friction: int = 400

func _ready() -> void:
    print("Running script on: ", name)
    print("Path: ", get_path())
    print("stats node found: ", get_node_or_null("stats"))
    print("stat_comp value: ", stat_comp)
    
func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
    
    if direction != Vector2.ZERO:
        velocity = direction * stat_comp.get_stat(stats.MOVE_SPEED)
    else:
        velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
        
    move_and_slide()
