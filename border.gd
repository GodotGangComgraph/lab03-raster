extends Control

var image : Image
var boundary_color : Color = Color.BLACK # Цвет границы (например, красный)
var draw_color : Color = Color.GREEN # Цвет, которым будем рисовать границу (например, зеленый)
var start_point : Vector2 # Начальная точка для обхода
var boundary_points : Array = [] # Список точек границы

func _ready():
	# Загрузка изображения
	var img_texture = preload("res://star.png")
	image = img_texture.get_image()
	
	# Получаем начальную точку границы
	start_point = find_boundary_start()

	if start_point:
		# Если начальная точка найдена, начинаем обход границы
		follow_boundary(start_point)

	# Прорисовываем результат поверх изображения
	queue_redraw()


# Метод для поиска первой точки границы
func find_boundary_start() -> Vector2:
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var pixel_color = image.get_pixel(x, y)
			if pixel_color == boundary_color:
				return Vector2(x, y) # Возвращаем первую найденную точку с цветом границы
	return Vector2(0, 0)


# Алгоритм обхода границы
func follow_boundary(start_point: Vector2):
	var current_point = start_point
	boundary_points.append(current_point)
	
	var directions = [Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1)]
	var current_direction = 0
	while true:
		var found_next = false
		for i in range(8):
			var direction_index = (current_direction + i) % 8 # Обход по кругу
			var direction = directions[direction_index]
			var next_point = current_point + direction
			var color = image.get_pixelv(next_point)
			if color == boundary_color:
				if next_point in boundary_points: # Если вернулись в начальную точку
					return
				boundary_points.append(next_point)
				#var lambda = func(vec: Vector2, vec2: Vector2):
				#	return vec[1] < vec2[1] or vec[0] < vec2[0]
				# boundary_points.sort_custom(lambda)
				current_point = next_point
				found_next = true
				current_direction = (direction_index + 6) % 8
				break
		
		if not found_next:
			break # Останавливаем обход, если граница закончилась


# Прорисовка границы
func _draw():
	# Рисуем исходное изображение
	draw_texture(ImageTexture.create_from_image(image), Vector2(0, 0))
	
	# Рисуем границу поверх изображения
	for point in boundary_points:
		draw_circle(point, 1, draw_color)

func _process(delta):
	queue_redraw() # Постоянно обновляем отрисовку
