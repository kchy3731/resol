extends Node

var score: int = 0
var streak: int = 0
var go_around: int = 0
var current_sequence: Array[int] = []
var running: bool = false

var inputs: Array[StringName] = ["game_red", "game_green", "game_yellow", "game_blue"]
@onready var buttons: Array
@onready var rings: Array

@onready var ruleset: Ruleset = Ruleset.new()

signal button_pressed(idx: int)
signal correct
signal wrong
signal new_rule(from: int, to: int)

func _ready() -> void:
	buttons = $"Base/Buttons".get_children()
	rings = $"Base/Rings".get_children()
	# run_game()

func _flash_up_all() -> void:
	for ring in rings:
		ring.flash_up()
func _flash_down_all() -> void:
	for ring in rings:
		ring.flash_down()
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

func _process_input() -> void:
	for i in range(inputs.size()):
		if Input.is_action_just_pressed(inputs[i]):
			buttons[i].flash_up()
		elif Input.is_action_just_released(inputs[i]):
			buttons[i].flash_down()
			button_pressed.emit(i)

	if Input.is_action_just_pressed("DEBUG_y"):
		_introduce_rule()
	if Input.is_action_just_pressed("DEBUG_r"):
		flash_incorrect()

func _introduce_rule() -> void:
	var rule = ruleset.produce_rule() # [from, to]
	new_rule.emit(rule[0], rule[1])
	
func make_sequence(length: int = 3, num_buttons: int = 4) -> Array[int]:
	var sequence: Array[int] = []
	sequence.resize(length)
	
	for i in range(length):
		sequence[i] = randi_range(0, num_buttons - 1)
	
	return sequence

func _hint() -> void:
	var this_go_around := go_around
	while go_around == this_go_around:
		for i in range(current_sequence.size()):
			var button_idx := current_sequence[i]
			await rings[button_idx].flash()
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(current_sequence.size() * 1.4).timeout

# true if done correctly, false if done incorrectly
func do_sequence(sequence: Array[int]) -> bool:
	for i in range(sequence.size()):
		var button_idx := sequence[i]
		var pressed_button_idx: int = await button_pressed
		
		if not ruleset.check(button_idx, pressed_button_idx):
			streak = 0
			go_around += 1
			wrong.emit()
			await flash_incorrect()
			return false
		
	go_around += 1
	streak += 1
	score += 1
	correct.emit()
	await flash_correct()
	return true

func run_game() -> void:
	running = true
	await get_tree().create_timer(2).timeout
	while true:
		@warning_ignore("integer_division")
		current_sequence = make_sequence(3 + max(streak / 2 - 3, 0))
		if go_around > 0 and streak != 0 and score % 2 == 0:
			_introduce_rule()
		_hint()
		await do_sequence(current_sequence)
		await get_tree().create_timer(0.3).timeout

func game_is_running() -> bool:
	return running

func _process(_delta: float) -> void:
	_process_input()
