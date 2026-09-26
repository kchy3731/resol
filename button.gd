extends TextureRect

@export var color: Color

func flash_up() -> void:
	var tween = get_tree().create_tween()
	# tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.01)
	tween.tween_property(self, "self_modulate", color * 10, 0.03)

func flash_down() -> void:
	var tween = get_tree().create_tween()
	# tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)
	tween.tween_property(self, "self_modulate", color, 0.01)
