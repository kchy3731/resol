extends Node

var _volume_linear = 0.3

var tones: Array[AudioStreamWAV] = [
	preload("res://assets/sounds/tone0.wav"),
	preload("res://assets/sounds/tone1.wav"),
	preload("res://assets/sounds/tone2.wav"),
	preload("res://assets/sounds/tone3.wav")
]

var keydowns: Array[AudioStreamWAV] = [
	preload("res://assets/sounds/keydown0.wav"),
	preload("res://assets/sounds/keydown1.wav"),
	preload("res://assets/sounds/keydown2.wav"),
	preload("res://assets/sounds/keydown3.wav")
]

var keyups: Array[AudioStreamWAV] = [
	preload("res://assets/sounds/keyup0.wav"),
	preload("res://assets/sounds/keyup1.wav"),
	preload("res://assets/sounds/keyup2.wav"),
	preload("res://assets/sounds/keyup3.wav")
]

var button_sounds: Array[AudioStreamPlayer] = []
var ring_sounds: Array[AudioStreamPlayer] = []
var keydown_sounds: Array[AudioStreamPlayer] = []
var keyup_sounds: Array[AudioStreamPlayer] = []

func _ready() -> void:
	button_sounds.resize(4)
	ring_sounds.resize(4)
	keydown_sounds.resize(4)
	keyup_sounds.resize(4)
	
	for i in range(4):
		button_sounds[i] = AudioStreamPlayer.new()
		button_sounds[i].autoplay = false
		button_sounds[i].stream = tones[i]
		add_child(button_sounds[i])
		
		ring_sounds[i] = AudioStreamPlayer.new()
		ring_sounds[i].autoplay = false
		ring_sounds[i].stream = tones[i]
		ring_sounds[i].pitch_scale = 0.5
		add_child(ring_sounds[i])
		
		keydown_sounds[i] = AudioStreamPlayer.new()
		keydown_sounds[i].autoplay = false
		keydown_sounds[i].stream = keydowns[i]
		add_child(keydown_sounds[i])
		
		keyup_sounds[i] = AudioStreamPlayer.new()
		keyup_sounds[i].autoplay = false
		keyup_sounds[i].stream = keyups[i]
		add_child(keyup_sounds[i])

func _input(event: InputEvent) -> void:
	for i in range(4):
		if event.is_action_pressed(%Simon.inputs[i]):
			button_sounds[i].volume_db = _volume()
			button_sounds[i].play()
			keydown_sounds[i].volume_db = _volume()
			keydown_sounds[i].play()
			return
		if event.is_action_released(%Simon.inputs[i]):
			keyup_sounds[i].volume_db = _volume()
			keyup_sounds[i].play()
			return

func volume_up() -> void:
	_volume_linear = min(_volume_linear + 0.01, 1)
	AudioServer.set_bus_volume_db(0, _volume())

func volume_down() -> void:
	_volume_linear = max(_volume_linear - 0.01, 0)
	AudioServer.set_bus_volume_db(0, _volume())

func _volume() -> float:
	if (_volume_linear <= 0.0): return -100.0
	return 20.0 * log(_volume_linear) / log(10)
