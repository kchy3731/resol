extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start"):
		if not %Simon.game_is_running():
			%MainMenu.hide()
			%TimerContainer.show()
			%ScoreLabel.show()
			%Simon.show()
			%Simon.run_game()
	elif event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("effects"):
		%EffectsRect.visible = not %EffectsRect.visible
	elif event.is_action_pressed("volume_up"):
		pass # TODO
	elif event.is_action_pressed("volume_down"):
		pass # TODO
	elif event.is_action_pressed("tutorial"):
		pass # TODO
