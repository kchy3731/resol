class_name Ruleset extends RefCounted

var _rules := [0, 1, 2, 3]
var _last := -1
var iter := 0

func _init(last: int = -1) -> void:
	reset()
	self._last = last

func reset() -> void:
	_rules = [0, 1, 2, 3]

func add_rule(from: int, to: int) -> bool:
	if _rules[from] == to:
		return false
	_rules[from] = to
	return true

func produce_rule() -> Array[int]:
	var from := randi_range(0, 3) if _last == -1 else _last
	var to := randi_range(0, 3)
	while !add_rule(from, to) and iter < 4:
		to = randi_range(0, 3)
	_last = to
	iter += 1
	return [from, to]

func check(want: int, got: int) -> bool:
	return _rules[want] == got
