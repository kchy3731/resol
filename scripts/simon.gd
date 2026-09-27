extends Node

var score: int = 0
var streak: int = 0
var go_around: int = -1
var game_round: int = 0
var current_sequence: Array[int] = []
var running: bool = false

var pause_game: bool = false
var reset_game: bool = false
var input_enabled: bool = false

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

func _flash_up_all() -> void:
	for ring in rings:
		ring.flash_up()
func _flash_down_all() -> void:
	for ring in rings:
		ring.flash_down()
	for button in buttons:
		button.flash_down()
func flash_correct(_game_round) -> void:
	for i in range(3):
		if _game_round != game_round: return
		_flash_up_all()
		await get_tree().create_timer(0.16).timeout
		if _game_round != game_round: return
		_flash_down_all()
		await get_tree().create_timer(0.16).timeout
func flash_incorrect(_game_round: int) -> void:
	_flash_up_all()
	if _game_round != game_round: return
	await get_tree().create_timer(1).timeout
	if _game_round != game_round: return
	_flash_down_all()

func _process_input() -> void:
	if not input_enabled: return
	for i in range(inputs.size()):
		if Input.is_action_just_pressed(inputs[i]):
			%Sound.keydown_sounds[i].play()
			buttons[i].flash_up()
		elif Input.is_action_just_released(inputs[i]):
			%Sound.keyup_sounds[i].play()
			buttons[i].flash_down()
			button_pressed.emit(i)


func _introduce_rule() -> void:
	var rule = ruleset.produce_rule() # [from, to]
	new_rule.emit(rule[0], rule[1])
	
func make_sequence(length: int = 3, num_buttons: int = 4) -> Array[int]:
	var sequence: Array[int] = []
	sequence.resize(length)
	
	for i in range(length):
		sequence[i] = randi_range(0, num_buttons - 1)
	
	return sequence

func _hint(_game_round: int) -> void:
	var this_go_around := go_around
	while go_around == this_go_around:
		for i in range(current_sequence.size()):
			if go_around != this_go_around or reset_game or _game_round != game_round: break
			var button_idx := current_sequence[i]
			%Sound.ring_sounds[button_idx].play()
			await rings[button_idx].flash()
			if _game_round != game_round: return
			await get_tree().create_timer(0.1).timeout
			if _game_round != game_round: return
		if _game_round != game_round: return
		await get_tree().create_timer(current_sequence.size() * 1.4).timeout

# true if done correctly, false if done incorrectly
func do_sequence(sequence: Array[int], _game_round: int) -> bool:
	for i in range(sequence.size()):
		var button_idx := sequence[i]
		var pressed_button_idx: int = await button_pressed
		if reset_game or _game_round != game_round: return false
		
		if not ruleset.check(button_idx, pressed_button_idx):
			streak = 0
			go_around += 1
			wrong.emit()
			await flash_incorrect(_game_round)
			return false
		
	go_around += 1
	streak += 1
	score += 1
	correct.emit()
	await flash_correct(_game_round)
	return true

func run_game() -> void:
	if running: return
	input_enabled = true
	running = true
	game_round += 1
	go_around = 0
	reset_game = false
	var _game_round := game_round
	while true:
		if reset_game or _game_round != game_round: break
		if pause_game: await get_tree().create_timer(0.1).timeout
		@warning_ignore("integer_division")
		current_sequence = make_sequence(3 + max(streak / 2 - 3, 0))
		if go_around > 0 and streak != 0 and score % 2 == 0:
			_introduce_rule()
		_hint(_game_round)
		await do_sequence(current_sequence, _game_round)
		if _game_round != game_round: break
		await get_tree().create_timer(0.3).timeout
	reset_game = false
	running = false

func reset() -> void:
	score = 0
	streak = 0
	go_around = -1
	game_round += 1
	current_sequence = []
	ruleset = Ruleset.new()
	pause_game = false
	reset_game = true
	input_enabled = false
	running = false
	_flash_down_all()

func _process(_delta: float) -> void:
	_process_input()
