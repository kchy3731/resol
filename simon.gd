extends Control

@export var red_button: TextureRect
@export var green_button: TextureRect
@export var yellow_button: TextureRect
@export var blue_button: TextureRect

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("game_red")):
		red_button.flash_up()
	elif (Input.is_action_just_released("game_red")):
		red_button.flash_down()
	
	if (Input.is_action_just_pressed("game_green")):
		green_button.flash_up()
	elif (Input.is_action_just_released("game_green")):
		green_button.flash_down()
	
	if (Input.is_action_just_pressed("game_yellow")):
		yellow_button.flash_up()
	elif (Input.is_action_just_released("game_yellow")):
		yellow_button.flash_down()
	
	if (Input.is_action_just_pressed("game_blue")):
		blue_button.flash_up()
	elif (Input.is_action_just_released("game_blue")):
		blue_button.flash_down()
