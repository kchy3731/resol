extends Control

func _ready() -> void:
    AudioServer.set_bus_volume_db(0, %Sound._volume())

func show_bar() -> void:
    if self.visible: return
    self.visible = true
    $"ShowTimer".start()

func hide_bar() -> void:
    self.visible = false