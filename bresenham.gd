extends Control

const NULLVEC2 = Vector2i(-1, -1)

var point1: Vector2i = NULLVEC2
var point2: Vector2i = NULLVEC2
var index: int = 0
@onready var v_scroll_bar: VScrollBar = $VBoxContainer/MarginContainer/HBoxContainer/VScrollBar

@onready var item_list: OptionButton = $VBoxContainer/MarginContainer/HBoxContainer/ItemList
@onready var margin_container: MarginContainer = $VBoxContainer/MarginContainer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.position[1] > margin_container.size[1]:
		if point1 == NULLVEC2:
			point1 = event.position
		elif point2 == NULLVEC2:
			point2 = event.position
		else:
			point1 = point2
			point2 = event.position
		queue_redraw()
		

func _draw():
	if point1 == NULLVEC2 or point2 == NULLVEC2:
		return
	if item_list.selected == 0:
			var local_point1 = point1 ; var local_point2 = point2
			var x0 = local_point1[0] ; var y0 = local_point1[1]
			var x1 = local_point2[0] ; var y1 = local_point2[1]
			draw_rect(Rect2(x0, y0, v_scroll_bar.value, v_scroll_bar.value), Color("#B8001F"))
			draw_rect(Rect2(x1, y1, v_scroll_bar.value, v_scroll_bar.value), Color("#B8001F"))
			var dx = abs(x1 - x0)
			var dy = abs(y1 - y0)
			var grad = dy * 1.0 / dx
			
			if abs(grad) <= 1:
				if local_point1[0] > local_point2[0]:
					var temp = local_point1
					local_point1 = local_point2
					local_point2 = temp
					x0 = local_point1[0] ; y0 = local_point1[1]
					x1 = local_point2[0] ; y1 = local_point2[1]
				var yi = 1 if local_point1[1] < local_point2[1] else -1
				var D = 2*dy - dx
				var y = y0
				
				for x in range(x0+v_scroll_bar.value, x1, v_scroll_bar.value):
					draw_rect(Rect2(x, y, v_scroll_bar.value, v_scroll_bar.value), Color("#FCFAEE"))
					if D >= 0:
						y = y + yi * v_scroll_bar.value
						D = D - 2*dx
					D = D + 2*dy
			else:
				if local_point1[1] > local_point2[1]:
					var temp = local_point1
					local_point1 = local_point2
					local_point2 = temp
					x0 = local_point1[0] ; y0 = local_point1[1]
					x1 = local_point2[0] ; y1 = local_point2[1]
				var xi = 1 if local_point1[0] < local_point2[0] else -1
				var D = 2*dx - dy
				var x = x0
				for y in range(y0+v_scroll_bar.value, y1, v_scroll_bar.value):
					draw_rect(Rect2(x, y, v_scroll_bar.value, v_scroll_bar.value), Color("#FCFAEE"))
					if D >= 0:
						x = x + xi * v_scroll_bar.value
						D = D - 2*dy
					D = D + 2*dx
	else:
		var local_point1 ; var local_point2
		if point1[0] > point2[0]:
			local_point1 = point2 ; local_point2 = point1
		else:
			local_point1 = point1 ; local_point2 = point2
		var x0 = local_point1[0] ; var y0 = local_point1[1]
		var x1 = local_point2[0] ; var y1 = local_point2[1]
		draw_rect(Rect2(x0, y0, v_scroll_bar.value, v_scroll_bar.value), Color("#B8001F"))
		draw_rect(Rect2(x1, y1, v_scroll_bar.value, v_scroll_bar.value), Color("#B8001F"))
		var dx = x1 - x0 ; var dy = y1 - y0
		var grad = dy * 1.0 / dx
		var y = y0 + grad
		for x in range(x0+v_scroll_bar.value, x1):
			draw_rect(Rect2(x, int(y), v_scroll_bar.value, v_scroll_bar.value), Color(Color("#FCFAEE"), 1-(y - int(y))))
			draw_rect(Rect2(x, int(y), v_scroll_bar.value, v_scroll_bar.value), Color(Color("#FCFAEE"), y - int(y)))
			y = y + grad


func _on_item_list_item_selected(index: int) -> void:
	queue_redraw()


func _on_v_scroll_bar_value_changed(value: float) -> void:
	queue_redraw()
