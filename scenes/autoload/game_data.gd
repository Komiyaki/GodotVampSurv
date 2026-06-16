extends Node

const DATA_PATH: String = "user://game_data.json"
const SAVE_PATH: String = "user://save_data.json"

const ENEMY_SCENE_PATH: String = "res://scenes/enemy/enemy.tscn"
const ENEMY_POOL_SIZE: int = 100

const ENEMY_SPAWN_FIELD_RANGE_X = 1280
const ENEMY_SPAWN_FIELD_RANGE_Y = 720
const ENEMY_SPAWN_FIELD_OFFSET = 32
const ENEMY_SPAWN_CAMERA_RANGE_SQR = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # _load_data()
    pass # Replace with function body.

func _load_data() -> void:
    if not FileAccess.file_exists(DATA_PATH):
        push_error("No data file found at %s" % DATA_PATH)
        return # Error! We don't have data to load.

    var data_file = FileAccess.open(DATA_PATH, FileAccess.READ)
    while data_file.get_position() < data_file.get_length():
        print(data_file.get_line())
        # var json_string = data_file.get_line()
        # var json = JSON.new()

        # var parse_result = json.parse(json_string)
        # if not parse_result == OK:
        #     push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
        #     continue

        # var node_data = json.data

func save_game() -> void:
    pass

func load_game() -> void:
    if not FileAccess.file_exists("user://save_data.json"):
        push_error("No save file found at %s" % SAVE_PATH)
        return # Error! We don't have a save to load.
    pass
