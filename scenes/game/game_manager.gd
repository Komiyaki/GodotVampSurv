extends Node2D
class_name GameManager

enum GameState {
FIRST_LOAD,
COUNTDOWN,
SPAWNING,
INTERROUND,
PAUSED,
ROUND_SWITCH,
GAME_OVER,
RESTART,
}

@export var ui_manager: UIManager
@export var enemy_manager: EnemyManager
@export var player: Node2D
@export var gm_round_timer: Timer
@export var gm_spawn_timer: Timer

@export var current_round: int = 0
@export var round_enemies_total: int = 0
@export var round_spawn_rate: int = 0

@export var interround_over: bool = true

var game_state: GameState = GameState.FIRST_LOAD:
    set(value):
        game_state = value
        ui_manager.display_game_state(GameState.keys()[game_state])


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _check_dependencies()

    gm_spawn_timer.wait_time = GameData.ENEMY_SPAWN_TIMER
    gm_round_timer.wait_time = GameData.INTERROUND_TIMER

    gm_spawn_timer.stop()
    gm_spawn_timer.stop()

    gm_spawn_timer.timeout.connect(spawn_enemies_tick)
    gm_round_timer.timeout.connect(end_interround)

       # get references to all necessary stuff, esp game_data autoload
    pass # Replace with function body.


func _check_dependencies() -> void:
    if ui_manager == null:
        push_error("No ui_manager set on %s" % name)
    if enemy_manager == null:
        push_error("No enemy_manager set on %s" % name)
    if gm_round_timer == null:
        push_error("No gm_round_timer set on %s" % name)
    if gm_spawn_timer == null:
        push_error("No gm_spawn_timer set on %s" % name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
       # enemies and the like should subscribe to game_manager events to listen for pause state (especially)

    match game_state:
        GameState.FIRST_LOAD:
            game_state = GameState.FIRST_LOAD
            print("%s performing first load" % name)
            # for now dont do much, just start spawning
            enemy_manager.fill_enemy_pool()
            # might play some intro animation or something idk
            game_state = GameState.ROUND_SWITCH

        GameState.SPAWNING:
            # spawn enemies at given times / intervals?? as defined in game_data for this round
            # check remaing enemies (or wait for signal from enemy_manager?)
            if round_enemies_total <= 0 and len(enemy_manager.enemy_pool_active.keys()) <= 0:
                gm_spawn_timer.stop()
                game_state = GameState.INTERROUND

        GameState.INTERROUND:
            # unused for now but could be used to mutation get animation
            if interround_over:
                game_state = GameState.ROUND_SWITCH

        GameState.PAUSED:
            # send signal to all subscribers (mostly enemies and animations) that game is paused (on pause and unpause)
            pass

        GameState.ROUND_SWITCH:
            # increment round counter, load enemy data for next round, start interround timer
            interround_over = false

            current_round += 1
            round_enemies_total = floor(
                GameData.SPAWN_FUNC_FACTOR_INITIAL +
                GameData.SPAWN_FUNC_FACTOR_LINEAR * current_round +
                pow(GameData.SPAWN_FUNC_FACTOR_EXP, current_round)
                )
            round_spawn_rate = floor(GameData.ENEMY_SPAWN_AMOUNT_INITIAL + GameData.SPAWN_FUNC_FACTOR_LINEAR * current_round)

            game_state = GameState.SPAWNING

            print("Started round {0} with {1} enemies, {2} every {3} seconds".format(
                {"0": current_round,
                "1": round_enemies_total,
                "2": round_spawn_rate,
                "3": GameData.ENEMY_SPAWN_TIMER}
            ))

            gm_spawn_timer.start()

        GameState.GAME_OVER:
            # show stats: rounds survived, enemies killed, mutations used, etc?
            # allow restart, or exit to menu
            pass

        GameState.RESTART:
            pass

        _:
            push_error("Unexpected GameState value on %s" % name)

func spawn_enemies_tick() -> void:
    var enemy_count: int = round_spawn_rate if round_spawn_rate <= round_enemies_total else round_enemies_total

    enemy_manager.spawn_n_enemies(enemy_count, player.position)
    round_enemies_total -= enemy_count

    print("%s Spawned %d enemies, %d remaining" % [name, enemy_count, round_enemies_total])

    # Stop spawning timer if spawned all enemies
    if round_enemies_total <= 0:
        gm_spawn_timer.stop()

func end_interround() -> void:
    interround_over = true
