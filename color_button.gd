class_name ColorButton extends Button

@export var input_action: String

@onready var color_rect: ColorRect = $ColorRect
@onready var default_color: Color = color_rect.color
@onready var thecolor: Color = default_color

var flash_mix := 0.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(input_action):
		button_down.emit()
		pressed.emit()
	elif event.is_action_released(input_action):
		button_up.emit()

func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_PASS
	button_down.connect(_button_down)
	button_up.connect(_button_up)

func _process(delta: float) -> void:
	color_rect.color = thecolor

func _button_down() -> void:
	thecolor = Color.BLACK
func _button_up() -> void:
	thecolor = default_color

func flash() -> void:
	pass
