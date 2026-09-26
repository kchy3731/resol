extends Node

@export var red_button: MeshInstance3D
@export var green_button: MeshInstance3D
@export var yellow_button: MeshInstance3D
@export var blue_button: MeshInstance3D

@export var red_ring: MeshInstance3D
@export var green_ring: MeshInstance3D
@export var yellow_ring: MeshInstance3D
@export var blue_ring: MeshInstance3D

func _flash_up_all() -> void:
	red_ring.flash_up()
	green_ring.flash_up()
	yellow_ring.flash_up()
	blue_ring.flash_up()

func _flash_down_all() -> void:
	red_ring.flash_down()
	green_ring.flash_down()
	yellow_ring.flash_down()
	blue_ring.flash_down()

func flash_correct() -> void:
	for i in range(3):
		_flash_up_all()
		await get_tree().create_timer(0.16).timeout
		_flash_down_all()
		await get_tree().create_timer(0.16).timeout

func flash_incorrect() -> void:
	_flash_up_all()
	await get_tree().create_timer(1).timeout
	_flash_down_all()

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
