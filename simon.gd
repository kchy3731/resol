extends Node

@export var red_button: MeshInstance3D
@export var green_button: MeshInstance3D
@export var yellow_button: MeshInstance3D
@export var blue_button: MeshInstance3D

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
