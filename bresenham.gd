extends Control

var point1: Vector2i = Vector2(0, 0)
var point2: Vector2i = Vector2(20, 15)

func _draw():
	var x0 = point1[0] ; var y0 = point1[1]
	var x1 = point2[0] ; var y1 = point2[1]
	draw_rect(Rect2(x0, y0, 1, 1), Color(255, 0, 0))
	draw_rect(Rect2(x1, y1, 1, 1), Color(255, 0, 0))
	var dx = x1 - x0
	var dy = y1 - y0
	var grad = dy * 1.0 / dx
	
	if grad <= 1:
		var D = 2*dy - dx
		var y = y0
		for x in range(x0, x1):
			draw_rect(Rect2(x, y, 1, 1), Color(255, 255, 255))
			if D >= 0:
				y = y + 1
				D = D - 2*dx
			D = D + 2*dy
	else:
		var D = 2*dx - dy
		var x = x0
		for y in range(y0, y1):
			draw_rect(Rect2(x, y, 1, 1), Color(255, 255, 255))
			if D >= 0:
				x = x + 1
				D = D - 2*dy
			D = D + 2*dx
