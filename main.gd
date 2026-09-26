extends Control

@onready var buttons: Array[Button] = [
	%Red, %Green, %Yellow, %Blue
]
var button_names: Array[String] = [
	"red", "green", "yellow", "blue"
]
#var button_waiting: Button = null

func make_sequence(length: int = 3, num_buttons: int = 4) -> Array[int]:
	var sequence: Array[int] = []
	sequence.resize(length)
	
	for i in range(length):
		sequence[i] = randi_range(0, num_buttons - 1)
	
	return sequence

func do_sequence(sequence: Array[int]) -> void:
	for i in range(sequence.size()):
		var button_idx := sequence[i]
		print("button_idx = %d" % button_idx)
		print("PLEASE PRESS THE %s BUTTON." % button_names[button_idx])
		
		await buttons[button_idx].pressed
	print("DONE!")

func _ready() -> void:
	print(buttons)
	do_sequence(make_sequence())

#func _process(_delta: float) -> void:
	#if button_waiting != null:
		#print("WAITING FOR ", button_waiting)
		#button_waiting = null
