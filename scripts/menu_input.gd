extends Control

signal game_start
signal menu_exit
signal menu_vfx_toggle
signal menu_vup
signal menu_vdown
signal menu_tutorial

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_start"):
		game_start.emit(false)
	elif event.is_action_pressed("menu_exit"):
		menu_exit.emit()
	elif event.is_action_pressed("menu_vfx"):
		%EffectsRect.visible = not %EffectsRect.visible
	elif event.is_action_pressed("menu_vup"):
		pass # TODO
	elif event.is_action_pressed("menu_vdown"):
		pass # TODO
	elif event.is_action_pressed("menu_tutorial"):
		game_start.emit(true)
