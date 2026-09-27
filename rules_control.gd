extends Control

var labels: Array[Label] = []
var to_add: Array[int] = []
var to_remove: int = 0 # labels before this index are scheduled to die
var positions: Array[float] = []
var margin: float = 16.0

@onready var font: Font = get_theme_font("font", "Label")
@onready var font_size: int = get_theme_font_size("font_size", "RuleLabel")

func _label_width(label: Label) -> float:
	return font.get_string_size(label.text).x * 42 / 16

func _total_width() -> float:
	var width := 0.0
	for i in range(to_remove, labels.size()):
		width += _label_width(labels[i])
		width += margin
	return width - margin

func _recompute_positions() -> void:
	positions.clear()
	var total_width := _total_width()
	var current_position: float = (size.x - total_width) / 2
	for i in range(to_remove, labels.size()):
		positions.append(current_position)
		current_position += _label_width(labels[i]) + margin

func add_label(text: String, color: Color) -> void:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
	label.modulate = Color(1, 1, 1, 0)
	to_add.append(labels.size())
	labels.append(label)
	add_child(label)

func pop_label() -> void:
	to_remove += 1

func draw() -> void:
	_recompute_positions()
	for i in range(labels.size()):
		if i < to_remove:
			# tween to fade out left and disappear
			var tween := create_tween()
			tween.set_parallel()
			tween.tween_property(labels[i], "modulate:a", 0, 0.15)
			tween.tween_property(labels[i], "position:x", 0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tween.chain().tween_callback(labels[i].queue_free)
		elif not to_add.has(i):
			var tween := create_tween()
			tween.set_parallel()
			tween.tween_property(labels[i], "position:x", positions[i - to_remove], 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			pass # tween to move to proper position
		else:
			labels[i].position = Vector2(positions[i - to_remove], +24)
			var tween := create_tween()
			tween.set_parallel()
			tween.tween_property(labels[i], "modulate:a", 1, 0.2)
			tween.tween_property(labels[i], "position:y", 0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			pass # tween to normal opacity and center
	to_add.clear()
	for i in range(to_remove): labels.pop_front()
	to_remove = 0
	await get_tree().create_timer(0.3).timeout
	# fix lists here

func _ready() -> void:
	pass
