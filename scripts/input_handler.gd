extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"):
		if not %Simon.game_is_running():
			owner.hide_main_menu()
	elif event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("effects"):
		%EffectsRect.visible = not %EffectsRect.visible
	elif event.is_action_pressed("volume_up"):
		AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0) + 1)
	elif event.is_action_pressed("volume_down"):
		AudioServer.set_bus_volume_db(0, AudioServer.get_bus_volume_db(0) - 1)
	elif event.is_action_pressed("mute"):
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
	elif event.is_action_pressed("tutorial"):
		pass # TODO
