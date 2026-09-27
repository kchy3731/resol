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
	elif event.is_action_pressed("menu_tutorial"):
		game_start.emit(true)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("menu_vup"):
		%Sound.volume_up()
		%SoundBar.show_bar()
		%SoundBarLinear.size.x = %Sound._volume_linear * 860
	elif Input.is_action_pressed("menu_vdown"):
		%Sound.volume_down()
		%SoundBar.show_bar()
		%SoundBarLinear.size.x = %Sound._volume_linear * 860

func _ready() -> void:
	if %Persistent.high_score > 0:
		%HighScoreLabel.text = "HIGH SCORE: %d" % %Persistent.high_score
	else:
		%HighScoreLabel.text = ""
