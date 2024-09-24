extends Button

@onready var triangle: Control = $".."

var dragging = false
var of = Vector2(0, 0)

var snap = 1


func _process(_delta: float) -> void:
	if dragging:
		var new_pos = get_global_mouse_position() - of
		position = Vector2(snapped(new_pos.x, snap), snapped(new_pos.y, snap))
		


#func  _gui_input(event : InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed:
			#if event.button_mask == MOUSE_BUTTON_RIGHT:
				#pass
			#if event.button_index == MOUSE_BUTTON_LEFT:
				#pass


func _on_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position


func _on_button_up() -> void:
	triangle.draw_triangle()
	dragging = false


func _on_color_changed(extra_arg_0: int) -> void:
	match (extra_arg_0):
		1: triangle.color_1 = self.color
		2: triangle.color_2 = self.color
		3: triangle.color_3 = self.color
	
	triangle.draw_triangle()
