class_name SimonButton extends MeshInstance3D

@export var lit_material: StandardMaterial3D
@export var dim_material: StandardMaterial3D

func flash_up() -> void:
	material_override = lit_material

func flash_down() -> void:
	material_override = dim_material

func flash(time: float = 0.3) -> void:
	flash_up()
	await get_tree().create_timer(time).timeout
	flash_down()
