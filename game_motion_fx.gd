extends Node

@onready var camera: Camera3D = %Camera3D

func correct() -> void:
	camera.fov = 68 

func incorrect() -> void:
	camera.fov = 62
	camera.rotation.x += randf_range(-0.05, -0.15)
	camera.rotation.y += randf_range(-0.1, 0.1)

func _process(delta: float) -> void:
	camera.fov = lerpf(camera.fov, 65, delta * 1.2)
	camera.rotation = lerp(camera.rotation, Vector3(), delta * 1.2)

func start() -> void:
	camera.fov = 63 
	camera.rotation = Vector3(0.5, 0.0, 0.0)

func lose() -> void:
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(camera, "fov", 55, 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(camera, "rotation:x", 0.25, 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(camera, "rotation:z", 0.15, 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(2.5).timeout
	
