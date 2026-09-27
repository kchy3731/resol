extends Node

var high_score: int = 0
var played_tutorial: bool = false
var volume_linear: float = 0.3

func get_save() -> Dictionary:
    return {
        "high_score": high_score,
        "played_tutorial": played_tutorial,
        "volume_linear": volume_linear,
    }

func save_game() -> void:
    var save_data: Dictionary = get_save()
    var json = JSON.new()
    json.encode(save_data)
    var file = FileAccess.open("user://save.json", FileAccess.WRITE)
    file.store_string(json.get_data())
    file.close()

func load_game() -> void:
    var file = FileAccess.open("user://save.json", FileAccess.READ)
    if file:
        var json = JSON.new()
        json.parse(file.get_as_text())
        var save_data = json.get_data()
        high_score = save_data["high_score"]
        played_tutorial = save_data["played_tutorial"]
        file.close()