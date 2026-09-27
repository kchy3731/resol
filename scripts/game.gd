extends Node

signal button_pressed(button_idx: int)

@onready var world: WorldEnvironment = %WorldEnvironment
@onready var simon: Node = %Simon

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

var go_around: int = 0
var score: int = 0
var streak: int = 0
var current_sequence: Array[int] = []

func _flash_correct() -> void:
	world.environment.background_color = Color(0.26, 0.9, 0.3)
	await simon.flash_correct()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _flash_incorrect() -> void:
	world.environment.background_color = Color(0.9, 0.2, 0.2)
	await simon.flash_incorrect()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _introduce_rule() -> void:
	var rule := ruleset.produce_rule() # [from, to]

	var count = %RulesControl.labels.size()
	if count >= 4:
		%RulesControl.pop_label()

	var label_text = WORD_GUIDE[rule[0]]
	%RulesControl.add_label(label_text, COLOR_GUIDE[rule[1]])
	await %RulesControl.draw()

	# var ch = %RulesContainer.get_children()
	# if ch.size() >= 4:
		# ch[0].queue_free()

	# var label: Label = Label.new()
	# label.text = "  " + WORD_GUIDE[rule[0]] + "  "
	# label.add_theme_color_override("font_color", COLOR_GUIDE[rule[1]])
	# label.add_theme_font_size_override("font_size", 48)
	# %RulesContainer.add_child(label)


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
			await _flash_incorrect()
			streak = 0
			go_around += 1
			return false
		
	score += 1
	go_around += 1
	%ScoreLabel.text = str(score)
	streak += 1
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
		@warning_ignore("integer_division")
		current_sequence = make_sequence(3 + max(streak / 2 - 3, 0))
		if score > 0 and streak != 0 and score % 2 == 0:
			await _introduce_rule()
		_hint()
		await do_sequence(current_sequence)
		await get_tree().create_timer(0.3).timeout

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_y"):
		_introduce_rule()
	if Input.is_action_just_pressed("DEBUG_r"):
		await _flash_incorrect()
