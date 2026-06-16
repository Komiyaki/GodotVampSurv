extends Node
class_name EnemyManager

@export var enemy_scene: PackedScene
@export var enemy_pool_inactive: Dictionary
@export var enemy_pool_active: Dictionary

@export var enemy_pool_count: int = 0

const ENEMY_SPAWN_RANGE_X: int = GameData.ENEMY_SPAWN_FIELD_RANGE_X - (GameData.ENEMY_SPAWN_FIELD_OFFSET * 2)
const ENEMY_SPAWN_RANGE_Y: int = GameData.ENEMY_SPAWN_FIELD_RANGE_Y - (GameData.ENEMY_SPAWN_FIELD_OFFSET * 2)

@export var inactive_node: Node2D
@export var active_node: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _check_dependencies()

    # Load PackedScene of enemy
    enemy_scene = load(GameData.ENEMY_SCENE_PATH)

    # Init empty dictionaries
    enemy_pool_active = Dictionary()
    enemy_pool_inactive = Dictionary()

    # Check enemy is PooledObject
    var new_enemy = enemy_scene.instantiate()
    assert(new_enemy is PooledObject)

    # Crash if not, add first to dict if so
    inactive_node.add_child(new_enemy)
    new_enemy.set_inactive()
    enemy_pool_inactive.set(enemy_pool_count, new_enemy)
    enemy_pool_count += 1

func _check_dependencies() -> void:
    if inactive_node == null:
        push_error("No inactive_node set on %s" % name)
    if active_node == null:
        push_error("No active_node set on %s" % name)

func fill_enemy_pool() -> void:
    _add_enemies_to_pool(GameData.ENEMY_POOL_SIZE)

func _add_enemies_to_pool(count: int = 0) -> void:
    print("populating enemy pool")
    while enemy_pool_count < count:
        var new_enemy = enemy_scene.instantiate()
        inactive_node.add_child(new_enemy)
        new_enemy.set_inactive()
        enemy_pool_inactive.set(enemy_pool_count, new_enemy)
        enemy_pool_count += 1

func spawn_n_enemies(count: int, camera_pos: Vector2) -> void:
    var spawn_pos: Vector2 = Vector2.ZERO
    for i in range(0, count):
        while true:
            spawn_pos.x = 32 + randi_range(0, ENEMY_SPAWN_RANGE_X)
            spawn_pos.y = 32 + randi_range(0, ENEMY_SPAWN_RANGE_Y)
            if spawn_pos.distance_squared_to(camera_pos) <= GameData.ENEMY_SPAWN_CAMERA_RANGE:
                break

            _spawn_enemy(spawn_pos)
        pass

func _spawn_enemy(location: Vector2) -> void:
    var enemy_id: int = enemy_pool_inactive.keys()[0]
    var enemy: PooledObject = enemy_pool_inactive.get(enemy_id)
    enemy_pool_active.set(enemy_id, enemy)
    enemy_pool_inactive.erase(enemy_id)

    active_node.add_child(enemy)
    enemy.position = location
    enemy.set_active()
    pass
