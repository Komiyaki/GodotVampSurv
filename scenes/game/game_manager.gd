extends Node2D
class_name GameManager

enum GameState {
   FIRST_LOAD,
   COUNTDOWN,
   SPAWNING,
   MUTATION_FRAMES,
   PAUSED,
   ROUND_SWITCH,
   GAME_OVER,
   RESTART,
}

@export var ui_manager: UIManager
@export var enemy_manager: EnemyManager

var game_state: GameState = GameState.FIRST_LOAD:
	set(value):
		game_state = value




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_check_dependencies()

	# get references to all necessary stuff, esp game_data autoload
	pass # Replace with function body.


func _check_dependencies() -> void:
	if ui_manager == null:
		push_error("No ui_manager set on %s" % name)
	if enemy_manager == null:
		push_error("No enemy_manager set on %s" % name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# enemy spawner should have a pool of objects to recycle, handled by enemy_manager
	# enemies and the like should subscribe to game_manager events to listen for pause state (especially)
	#

	match game_state:
		GameState.FIRST_LOAD:
			# for now dont do much, just start spawning
			# might play some intro animation or something idk
			pass
		GameState.SPAWNING:
			# spawn enemies at given times / intervals?? as defined in game_data for this round
			# check remaing enemies (or wait for signal from enemy_manager?)
			pass
		GameState.MUTATION_FRAMES:
			# unused for now but could be used to mutation get animation
			pass
		GameState.PAUSED:
			# send signal to all subscribers (mostly enemies and animations) that game is paused (on pause and unpause)
			pass
		GameState.ROUND_SWITCH:
			# increment round counter, load enemy data for next round, start interround timer
			pass
		GameState.GAME_OVER:
			# show stats: rounds survived, enemies killed, mutations used, etc?
			# allow restart, or exit to menu
			pass
		GameState.RESTART:
			pass
		_:
			pass
