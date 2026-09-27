extends Node

@onready var world: WorldEnvironment = %WorldEnvironment
@onready var main_menu: Control = %MainMenu
@onready var simon: Node = %Simon
@onready var game_timer: Timer = %GameTimer
@onready var motion_fx: Node = %GameMotionFX

var game_is_running: bool = false
var tutorial_is_running: bool = false

@export var game_time: float = 90

const WORD_GUIDE: Dictionary[int, StringName] = {
	0: "Red",
	1: "Green",
	2: "Yellow",
	3: "Blue",
}

const COLOR_GUIDE: Dictionary[int, Color] = {
	0: Color(0.95, 0.3, 0.3), # red
	1: Color(0.3, 0.8, 0.3), # green
	2: Color(0.7, 0.7, 0.25), # yellow
	3: Color(0.3, 0.4, 0.95), # blue
}

func _flash_correct() -> void:
	world.environment.background_color = Color(0.26, 0.9, 0.3)
	await get_tree().create_timer(0.8).timeout
	if not game_is_running: return
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _flash_incorrect() -> void:
	world.environment.background_color = Color(0.9, 0.2, 0.2)
	await get_tree().create_timer(0.8).timeout
	if not game_is_running: return
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _add_time(time: float) -> void:
	%TimerUpdate.add_time(time)
	var current_time := game_timer.time_left
	game_timer.start(current_time + time)

func _lose_time(time: float) -> void:
	%TimerUpdate.lose_time(time)
	var current_time := game_timer.time_left
	if current_time - time <= 0:
		game_timer.wait_time = 0
		game_timer.stop()
		_on_time_out()
		return
	game_timer.start(current_time - time)

func _correct() -> void:
	if not tutorial_is_running:
		_add_time(3)
		%ScoreLabel.text = str(simon.score)
		%Persistent.save_game()
	motion_fx.correct()
	_flash_correct()

func _wrong() -> void:
	if not tutorial_is_running:
		_lose_time(7.5)
		%ScoreLabel.text = str(simon.score)
		%Persistent.save_game()
	motion_fx.incorrect()
	_flash_incorrect()

func _disable_input() -> void:
	simon.input_enabled = false

func _enable_input() -> void:
	simon.input_enabled = true

func _on_new_rule(input: int, output: int) -> void:
	%RulesControl.add_label(WORD_GUIDE[input], COLOR_GUIDE[output])
	if %RulesControl.labels.size() > 4:
		%RulesControl.pop_label()
	%RulesControl.draw()

func _on_start_game(tutorial: bool) -> void:
	if game_is_running: return
	game_is_running = true
	main_menu.hide()
	if not tutorial:
		%TimerContainer.show()
		%ScoreLabel.show()
		game_timer.start(game_time + 2.5)
	else:
		tutorial_is_running = true
	simon.show()
	motion_fx.start()
	await get_tree().create_timer(2.5).timeout
	if not game_is_running: return
	if tutorial:
		simon.run_tutorial()
	else:
		simon.run_game()
	simon.input_enabled = true

func _ready() -> void:
	simon.new_rule.connect(_on_new_rule)
	simon.correct.connect(_correct)
	simon.wrong.connect(_wrong)
	simon.tutorial_done.connect(_on_tutorial_done)
	main_menu.game_start.connect(_on_start_game)
	%Persistent.load_game()
	%Sound._volume_linear = %Persistent.volume_linear
	if (not %Persistent.played_tutorial):
		tutorial_is_running = true
		_on_start_game(true)

func _on_tutorial_done() -> void:
	tutorial_is_running = false
	game_is_running = false
	%Persistent.played_tutorial = true
	%Persistent.save_game()
	simon.reset()
	_disable_input()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)
	%RulesControl.clear_rules()
	main_menu.show()
	%MainMenu._ready()
	
func _on_time_out() -> void:
	%Persistent.high_score = max(%Persistent.high_score, simon.score)
	%Persistent.save_game()
	if not game_is_running: return
	game_is_running = false
	game_timer.stop()
	simon.pause_game = true
	await motion_fx.lose()
	simon.reset()
	_disable_input()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)
	main_menu.show()
	%RulesControl.clear_rules()
	%TimerContainer.hide()
	%ScoreLabel.hide()
	%ScoreLabel.text = str(0)
	%MainMenu._ready()

func _process(_delta: float) -> void:
	%TimerLabel.text = "%.1f" % game_timer.time_left
	if Input.is_action_just_pressed("DEBUG_y"):
		_add_time(5)
	if Input.is_action_just_pressed("DEBUG_r"):
		_lose_time(5)
