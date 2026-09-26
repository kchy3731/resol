extends Node

signal button_pressed(button_idx: int)

@onready var world: WorldEnvironment = %WorldEnvironment
@onready var simon: Node = %Simon

@onready var buttons: Array[SimonButton] = [
	%Red, %Green, %Yellow, %Blue
]
@onready var rings: Array[SimonButton] = [
	%Red_Ring, %Green_Ring, %Yellow_Ring, %Blue_Ring
]

var input_action_names: Array[String] = [
	"game_red", "game_green", "game_yellow", "game_blue"
]

var ruleset := Ruleset.new()

func _flash_correct() -> void:
	world.environment.background_color = Color(0.26, 0.9, 0.3)
	await simon.flash_correct()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _flash_incorrect() -> void:
	world.environment.background_color = Color(0.9, 0.2, 0.2)
	await simon.flash_incorrect()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)


func _disable_input() -> void:
	pass

func _enable_input() -> void:
	pass

func make_sequence(length: int = 3, num_buttons: int = 4) -> Array[int]:
	var sequence: Array[int] = []
	sequence.resize(length)
	
	for i in range(length):
		sequence[i] = randi_range(0, num_buttons - 1)
	
	return sequence

# true if done correctly, false if done incorrectly
func do_sequence(sequence: Array[int]) -> bool:
	_disable_input()
	
	for i in range(sequence.size()):
		var button_idx := sequence[i]
		await rings[button_idx].flash()
		await get_tree().create_timer(0.1).timeout
	
	_enable_input()
	
	for i in range(sequence.size()):
		var button_idx := sequence[i]
		var pressed_button_idx: int = await button_pressed
		
		if not ruleset.check(button_idx, pressed_button_idx):
			await _flash_incorrect()
			return false
		
	await _flash_correct()
	return true


func _input(event: InputEvent) -> void:
	for i in range(input_action_names.size()):
		if event.is_action_pressed(input_action_names[i]):
			button_pressed.emit(i)

func _ready() -> void:
	run()

func run() -> void:
	await get_tree().create_timer(2).timeout
	while true:
		await do_sequence(make_sequence())
		await get_tree().create_timer(0.3).timeout

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_y"):
		await _flash_correct()
	if Input.is_action_just_pressed("DEBUG_r"):
		await _flash_incorrect()
