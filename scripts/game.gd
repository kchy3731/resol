extends Node

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

func _flash_correct() -> void:
	world.environment.background_color = Color(0.26, 0.9, 0.3)
	await simon.flash_correct()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

func _flash_incorrect() -> void:
	world.environment.background_color = Color(0.9, 0.2, 0.2)
	await simon.flash_incorrect()
	world.environment.background_color = Color(212/255.0, 220/255.0, 219/255.0)

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
