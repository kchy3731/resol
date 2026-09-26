class_name Ruleset extends RefCounted

var num_rules := 0
var from_arr: Array[int] = []
var to_arr: Array[int] = []
var broken_rule := -1

func _init() -> void:
	set_default_rules()

func reset() -> void:
	num_rules = 0
	from_arr.clear()
	to_arr.clear()

func set_default_rules(num: int = 4) -> void:
	num_rules = num
	from_arr.resize(num)
	to_arr.resize(num)
	for i in range(num):
		from_arr[i] = i
		to_arr[i] = i

func add(from: int, to: int) -> void:
	num_rules += 1
	from_arr.append(from)
	to_arr.append(to)

func remove_rule(idx: int) -> void:
	num_rules -= 1
	from_arr.remove_at(idx)
	to_arr.remove_at(idx)

func check(want: int, got: int) -> bool:
	for i in range(num_rules):
		if from_arr[i] == want:
			if to_arr[i] == got:
				return true
			else:
				broken_rule = i
				return false
	broken_rule = -1
	return false

func get_broken_rule() -> int:
	return broken_rule

func draw(node: CanvasItem, pos: Vector2) -> void:
	node.draw_rect(Rect2(pos, Vector2(100, 00)), Color.WHITE)
