extends Node
class_name stats

signal stat_changed(stat_name: StringName, new_value: int)

const MOVE_SPEED := &"move_speed"
const DAMAGE := &"damage"
const DEFENSE := &"defense"

@export_group("Base Stats")
@export var base_move_speed : int = 80
@export var base_damage: int = 40
@export var base_defense: int = 0

var _modifiers: Dictionary = {}


func get_stat(stat_name: StringName) -> int:
	var base_values := _get_base_value(stat_name)
	var upgrade := 0
	
	for modifier in _modifiers.values():
		if modifier["stat_name"] != stat_name:
			continue
		
		upgrade += modifier["flat"]
		
	return max(0, base_values + upgrade)
	
func add_modifier(id: StringName, stat_name: StringName, flat: int) -> void:
	_modifiers[id] = {
		"stat_name": stat_name,
		"flat": flat
	}
	
	stat_changed.emit(stat_name, get_stat(stat_name))
	
func _get_base_value(stat_name: StringName) -> int:
	match stat_name:
		MOVE_SPEED:
			return base_move_speed
		DAMAGE:
			return base_damage
		DEFENSE:
			return base_defense
		_:
			push_warning("Unknown stat" + str(stat_name))
			return 0
