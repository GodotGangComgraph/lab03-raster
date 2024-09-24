extends Node

# Выбранный цвет для заливки
var fill_color

# Цвет границы фигуры (треугольника)
var boundary_color = Color.BLACK

# Текстура для отображения изображения
var image_texture: ImageTexture

@onready var color_picker_button: ColorPickerButton = $VBoxContainer/MarginContainer/HBoxContainer/ColorPickerButton
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var option_button: OptionButton = $VBoxContainer/MarginContainer/HBoxContainer/OptionButton

#const picture = preload("res://ФРУКТЫ.jpg")
const picture = preload("res://RWAH.png")

var picture_image: Image


func _ready():
	picture_image = picture.get_image()
	
	fill_color = color_picker_button.color
	
	clear()



func clear():
	var image = Image.new()
	image = Image.create_empty(800, 600, false, Image.FORMAT_RGB8)
	# Устанавливаем фон белого цвета
	for x in range(800):
		for y in range(600):
			image.set_pixel(x, y, Color.WHITE)
	
	# Рисуем треугольник с вершинами (128, 50), (50, 200), (200, 200)
	_draw_filled_triangle(image, Vector2(250, 50), Vector2(50, 500), Vector2(500, 500))
	
	# Создаем текстуру из изображения
	image_texture = ImageTexture.create_from_image(image)
	
	# Добавляем изображение как Sprite на сцену
	texture_rect.texture = image_texture


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
	var length = start.distance_to(end) + 1
	for i in range(int(length)):
		var current_point = start + direction * i
		image.set_pixelv(current_point, boundary_color)

# Функция для заливки треугольника от стартовой точки
func fill(start_x: int, start_y: int):
	var image = image_texture.get_image()
	
	var start_color = image.get_pixel(start_x, start_y)
	
	if start_color == fill_color or start_color == boundary_color:
		return
	
	_fill_scanline(image, start_x, start_y, start_color)
	
	image_texture = ImageTexture.create_from_image(image)

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


# Функция для заливки треугольника от стартовой точки
func fill_2(start_x: int, start_y: int):
	var image = image_texture.get_image()
	
	_fill_scanline_2(image, start_x, start_y)
	
	image_texture = ImageTexture.create_from_image(image)


# Функция для заливки с использованием сканирования
func _fill_scanline_2(image: Image, start_x: int, start_y: int):
	var stack = []
	stack.append(Vector2(start_x, start_y))
	
	var image_x: int = picture_image.get_width()
	var image_y: int = picture_image.get_height()
	
	while stack.size() > 0:
		var point = stack.pop_back()
		var x: int = point.x
		var y: int = point.y
	
		# Заливаем текущий пиксель
		image.set_pixel(x, y, picture_image.get_pixel(x % image_x, y % image_y))
		
		# Заливка по горизонтали (влево и вправо)
		var left = x
		while left > 0 and image.get_pixel(left - 1, y) == Color.WHITE:
			left -= 1
			image.set_pixel(left, y, picture_image.get_pixel(left % image_x, y % image_y))

		var right = x
		while right < image.get_width() - 1 and image.get_pixel(right + 1, y) == Color.WHITE:
			right += 1
			image.set_pixel(right, y, picture_image.get_pixel(right % image_x, y % image_y))

		# Добавляем верхние и нижние пиксели в стек
		for new_x in range(left, right + 1):
			if y > 0 and image.get_pixel(new_x, y - 1) == Color.WHITE:
				stack.append(Vector2(new_x, y - 1))
			if y < image.get_height() - 1 and image.get_pixel(new_x, y + 1) == Color.WHITE:
				stack.append(Vector2(new_x, y + 1))


# Обработка нажатия кнопки заливки
func _on_fill_button_pressed():
	var start_x = 300
	var start_y = 300
	
	if option_button.selected == 0:
		fill(start_x, start_y)
	else:
		fill_2(start_x, start_y)

	texture_rect.texture = image_texture


func _on_color_picker_button_popup_closed() -> void:
	fill_color = color_picker_button.color


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
