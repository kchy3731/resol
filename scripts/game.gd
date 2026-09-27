extends Node

@onready var world: WorldEnvironment = %WorldEnvironment
@onready var simon: Node = %Simon
@onready var game_timer: Timer = %GameTimer

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
	await simon.flash_correct()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _flash_incorrect() -> void:
	world.environment.background_color = Color(0.9, 0.2, 0.2)
	await simon.flash_incorrect()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _add_time(time: float) -> void:
	%TimerUpdate.add_time(time)
	var current_time := game_timer.time_left
	game_timer.wait_time = current_time + time
	game_timer.start()

func _lose_time(time: float) -> void:
	%TimerUpdate.lose_time(time)
	var current_time := game_timer.time_left
	game_timer.wait_time = current_time - time
	game_timer.start()

func _correct() -> void:
	%ScoreLabel.text = str(simon.score)
	_flash_correct()

func _wrong() -> void:
	%ScoreLabel.text = str(simon.score)
	_flash_incorrect()

func _disable_input() -> void:
	pass

func _enable_input() -> void:
	pass

func _on_new_rule(input: int, output: int) -> void:
	%RulesControl.add_label(WORD_GUIDE[input], COLOR_GUIDE[output])
	if %RulesControl.labels.size() > 4:
		%RulesControl.pop_label()
	%RulesControl.draw()

func _ready() -> void:
	simon.new_rule.connect(_on_new_rule)
	simon.correct.connect(_correct)
	simon.wrong.connect(_wrong)
	await get_tree().create_timer(2).timeout
	simon.run_game()
	game_timer.start()
	
func _on_time_out() -> void:
	# player loses here
	pass

func _process(_delta: float) -> void:
	%TimerLabel.text = "%.1f" % game_timer.time_left
	if Input.is_action_just_pressed("DEBUG_y"):
		_add_time(5)
	if Input.is_action_just_pressed("DEBUG_r"):
		_lose_time(5)
