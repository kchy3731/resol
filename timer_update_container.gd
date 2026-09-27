extends Control

var green: Color = Color(0.3, 0.8, 0.3)
var red: Color = Color(0.95, 0.3, 0.3)

func add_time(time: float) -> void:
	var label: Label = Label.new()
	label.text = "+%.2f" % time
	label.add_theme_color_override("font_color", green)
	label.add_theme_font_size_override("font_size", 24)
	add_child(label)
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(label, "modulate:a", 0, 0.8)
	tween.tween_property(label, "position:y", -6, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(label.queue_free)

func lose_time(time: float) -> void:
	var label: Label = Label.new()
	label.text = "-%.2f" % time
	label.add_theme_color_override("font_color", red)
	label.add_theme_font_size_override("font_size", 24)
	add_child(label)
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(label, "modulate:a", 0, 0.8)
	tween.tween_property(label, "position:y", +6, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_callback(label.queue_free)