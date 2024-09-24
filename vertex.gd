extends Button

@onready var triangle: Control = $".."

var dragging = false
var of = Vector2(0, 0)

var snap = 1


func _process(_delta: float) -> void:
	if dragging:
		var new_pos = get_global_mouse_position() - of
		position = Vector2(snapped(new_pos.x, snap), snapped(new_pos.y, snap))


func _on_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position


func _on_button_up() -> void:
	triangle.draw_triangle()
	dragging = false
