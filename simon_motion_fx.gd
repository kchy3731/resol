extends Node

@export var base: Node3D

@export var red_button: Node3D
@export var green_button: Node3D
@export var yellow_button: Node3D
@export var blue_button: Node3D

@export var apex: float = 0.0005

var base_position: Vector3
var base_rotation: Vector3

func _ready() -> void:
	# base.global_position.y -= apex / 2
	base_position = base.global_position
	base_rotation = base.global_rotation

func _process(_delta: float) -> void:
	# base.global_position.y += sin(Time.get_ticks_msec() * 0.001) * apex

	var position_delta = Vector3()
	var rotation_delta = Vector3()

	if (Input.is_action_pressed("game_red")):
		rotation_delta.y -= 0.25
		position_delta.z -= 0.1
		red_button.position.y = 0.066
	else: red_button.position.y = 0.166
	if (Input.is_action_pressed("game_green")):
		rotation_delta.y -= 0.1
		position_delta.z -= 0.1
		green_button.position.y = 0.066
	else: green_button.position.y = 0
	if (Input.is_action_pressed("game_yellow")):
		rotation_delta.y += 0.1
		position_delta.z -= 0.1
		yellow_button.position.y = 0.066
	else: yellow_button.position.y = 0.166
	if (Input.is_action_pressed("game_blue")):
		rotation_delta.y += 0.25
		position_delta.z -= 0.1
		blue_button.position.y = 0.066
	else: blue_button.position.y = 0.166

	var target_position = base_position + position_delta
	var target_rotation = base_rotation + rotation_delta
	base.global_position = lerp(base.global_position, target_position, _delta * 25.0)
	base.global_rotation = lerp(base.global_rotation, target_rotation, _delta * 30.0)
