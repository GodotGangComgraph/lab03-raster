extends Node

# Выбранный цвет для заливки
var fill_color = Color.WHITE

# Цвет границы фигуры (треугольника)
var boundary_color = Color.BLACK

# Текстура для отображения изображения
var image_texture: ImageTexture

func _ready():
	# Создание изображения 256x256 пикселей
	var image = Image.new()
	image.create(256, 256, false, Image.FORMAT_RGB8)
	
	# Устанавливаем фон белого цвета
	for x in range(256):
		for y in range(256):
			image.set_pixel(x, y, Color.WHITE)
	
	# Рисуем треугольник с вершинами (128, 50), (50, 200), (200, 200)
	_draw_filled_triangle(image, Vector2(128, 50), Vector2(50, 200), Vector2(200, 200))

	# Создаем текстуру из изображения
	image_texture = ImageTexture.new()
	image_texture.create_from_image(image)
	
	# Добавляем изображение как Sprite на сцену
	var sprite = Sprite2D.new()
	sprite.texture = image_texture
	add_child(sprite)

	# Настройка OptionButton
	var option_button = $VBoxContainer/MarginContainer/HBoxContainer/OptionButton
	option_button.add_item("Обычная заливка")
	option_button.add_item("Другой тип заливки")  # Добавьте другие варианты, если нужно

# Функция для рисования треугольника на изображении
func _draw_filled_triangle(image: Image, p1: Vector2, p2: Vector2, p3: Vector2):
	var points = [p1, p2, p3]
	points.sort_custom(func(a, b): return a.y < b.y)

	var v1 = points[0]
	var v2 = points[1]
	var v3 = points[2]

	_draw_triangle_edge(image, v1, v2)
	_draw_triangle_edge(image, v2, v3)
	_draw_triangle_edge(image, v1, v3)

# Функция для рисования линии между двумя точками
func _draw_triangle_edge(image: Image, start: Vector2, end: Vector2):
	var direction = (end - start).normalized()
	var length = start.distance_to(end)
	for i in range(int(length)):
		var current_point = start + direction * i
		image.set_pixelv(current_point, boundary_color)

# Функция для заливки треугольника от стартовой точки
func fill(start_x: int, start_y: int):
	var image = image_texture.get_data() # Получаем данные изображения
	image.lock() # Блокируем для редактирования
	
	var start_color = image.get_pixel(start_x, start_y)
	
	if start_color == fill_color or start_color == boundary_color:
		image.unlock()
		return
	
	_fill_scanline(image, start_x, start_y, start_color)
	
	image.unlock() # Разблокируем для применения изменений
	image_texture.create_from_image(image)

# Функция для заливки с использованием сканирования
func _fill_scanline(image: Image, start_x: int, start_y: int, start_color: Color):
	var stack = []
	stack.append(Vector2(start_x, start_y))

	while stack.size() > 0:
		var point = stack.pop_back()
		var x = point.x
		var y = point.y

		# Заливаем текущий пиксель
		image.set_pixel(x, y, fill_color)

		# Заливка по горизонтали (влево и вправо)
		var left = x
		while left > 0 and image.get_pixel(left - 1, y) == start_color:
			left -= 1
			image.set_pixel(left, y, fill_color)

		var right = x
		while right < image.get_width() - 1 and image.get_pixel(right + 1, y) == start_color:
			right += 1
			image.set_pixel(right, y, fill_color)

		# Добавляем верхние и нижние пиксели в стек
		for new_x in range(left, right + 1):
			if y > 0 and image.get_pixel(new_x, y - 1) == start_color:
				stack.append(Vector2(new_x, y - 1))
			if y < image.get_height() - 1 and image.get_pixel(new_x, y + 1) == start_color:
				stack.append(Vector2(new_x, y + 1))

# Обработка нажатия кнопки заливки
func _on_fill_button_pressed():
	var start_x = 128
	var start_y = 150
	fill(start_x, start_y)
