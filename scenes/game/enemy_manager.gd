extends Node
class_name EnemyManager

@export var enemy_scene: PackedScene
@export var enemy_pool_inactive: Dictionary
@export var enemy_pool_active: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    enemy_scene = load(GameData.ENEMY_SCENE_PATH)

    enemy_pool_active = Dictionary()
    enemy_pool_inactive = Dictionary()

    # Check enemy is PooledObject
    var new_enemy = enemy_scene.instantiate()
    assert(new_enemy is PooledObject)
    enemy_pool_inactive.set(0, new_enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func fill_enemy_pool() -> void:
    for i in range(1, GameData.ENEMY_POOL_SIZE):
        var new_enemy = enemy_scene.instantiate()
        # TODO: set new enemy id, processing and the like to off

        #
        enemy_pool_inactive.set(i, new_enemy)
        pass


func spawn_enemy() -> void:
    pass
