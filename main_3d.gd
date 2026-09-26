extends Node

@export var disabled_color: Color
@export var correct_color: Color
@export var incorrect_color: Color

# @onready var rules_control: Control = $RulesControl
@onready var container_bg: StandardMaterial3D = %Base.get_active_material(0)
@onready var bg_default_color: Color = container_bg.albedo_color

@onready var buttons: Array[SimonButton] = [
	%Red, %Green, %Yellow, %Blue
]
@onready var rings: Array[SimonButton] = [
	%Red_Ring, %Green_Ring, %Yellow_Ring, %Blue_Ring
]

var button_names: Array[String] = [
	"red", "green", "yellow", "blue"
]
var input_action_names: Array[String] = [
	"game_red", "game_green", "game_yellow", "game_blue"
]
#var button_waiting: Button = null

var ruleset := Ruleset.new()

func flash_bg(flash_color: Color, time: float = 0.5) -> void:
	var old_color := container_bg.albedo_color
	container_bg.albedo_color = flash_color
	await get_tree().create_timer(time).timeout
	container_bg.albedo_color = old_color

func set_disabled(disabled: bool) -> void:
	container_bg.albedo_color = disabled_color if disabled else bg_default_color
	#for button in buttons:
		#button.disabled = disabled

func make_sequence(length: int = 3, num_buttons: int = 4) -> Array[int]:
	var sequence: Array[int] = []
	sequence.resize(length)
	
	for i in range(length):
		sequence[i] = randi_range(0, num_buttons - 1)
	
	return sequence

# true if done correctly, false if done incorrectly
func do_sequence(sequence: Array[int]) -> bool:
	set_disabled(true)
	
	for i in range(sequence.size()):
		var button_idx := sequence[i]
		await rings[button_idx].flash()
		await get_tree().create_timer(0.3).timeout
	
	set_disabled(false)
	
	for i in range(sequence.size()):
		var button_idx := sequence[i]
		var pressed_button_idx: int = await button_pressed
		
		if not ruleset.check(button_idx, pressed_button_idx):
			await flash_bg(incorrect_color)
			return false
		
	await flash_bg(correct_color)
	return true

signal button_pressed(button_idx: int)

func _input(event: InputEvent) -> void:
	for i in range(input_action_names.size()):
		if event.is_action_pressed(input_action_names[i]):
			button_pressed.emit(i)

func _ready() -> void:
	#rules_control.draw.connect(
		#func(): ruleset.draw(rules_control, button_names, get_theme_default_font())
	#)
	
	run()

func run() -> void:
	await get_tree().create_timer(0.5).timeout
	while true:
		await do_sequence(make_sequence())
		await get_tree().create_timer(0.3).timeout

#func _process(_delta: float) -> void:
	#if button_waiting != null:
		#print("WAITING FOR ", button_waiting)
		#button_waiting = null
