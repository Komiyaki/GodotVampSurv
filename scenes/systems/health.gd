extends Node
class_name health

signal health_change(current_health: int, max_health: int)
signal dead

@export var max_health: int = 100
@export var stat_comp: stats

var current_health: int
var is_dead: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    current_health = max_health
    health_change.emit(current_health, max_health)

func take_damage(damage_amt: int) -> void:
    var defense := 0
    if stat_comp != null:
        defense = stat_comp.get_stat(stats.DEFENSE)
    current_health = current_health - (damage_amt - defense)
    if current_health <= 0:
        is_dead = true
        dead.emit()
        current_health = 0
    health_change.emit(current_health, max_health)


func heal(heal_amt: int) -> void:
    if (current_health + heal_amt) > max_health:
        current_health = max_health
    else:
        current_health += heal_amt
    health_change.emit(current_health, max_health)
    
func increase_max_health(amount_inc: int) -> void:
    max_health += amount_inc
    heal(amount_inc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
