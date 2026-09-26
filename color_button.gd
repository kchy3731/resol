class_name ColorButton extends Button

@export var input_action: String

@onready var color_rect: ColorRect = $ColorRect
@onready var default_color: Color = color_rect.color
@onready var thecolor: Color = default_color

var flash_mix := 0.0

func _input(event: InputEvent) -> void:
	if disabled:
		return
	if event.is_action_pressed(input_action):
		button_down.emit()
		pressed.emit()
	elif event.is_action_released(input_action):
		button_up.emit()

func _ready() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_PASS
	button_down.connect(_button_down)
	button_up.connect(_button_up)

func _process(_delta: float) -> void:
	pass
	# color_rect.color = thecolor

func _button_down() -> void:
	color_rect.color = Color.BLACK
func _button_up() -> void:
	color_rect.color = default_color

func flash(time: float = 0.5) -> void:
	color_rect.color = lerp(default_color, Color.WHITE, 0.7)
	await get_tree().create_timer(time).timeout
	color_rect.color = default_color
