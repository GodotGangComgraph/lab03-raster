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
@onready var fill_button: Button = $VBoxContainer/MarginContainer/HBoxContainer/Button4

#const picture = preload("res://ФРУКТЫ.jpg")
const picture = preload("res://RWAH.png")

var picture_image: Image
var image: Image = Image.new()
var drawing = false

func _ready():
	picture_image = picture.get_image()
	
	fill_color = color_picker_button.color
	
	clear()


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			if not fill_button.button_pressed:
				image.set_pixel(event.position.x, event.position.y, color_picker_button.color)
				image_texture = ImageTexture.create_from_image(image)
				drawing = true
				texture_rect.texture = image_texture
			else:
				if option_button.selected == 0:
					fill(event.position.x, event.position.y)
				else:
					fill_2(event.position.x, event.position.y)
				texture_rect.texture = image_texture
			
		if event.button_index == 1 and not event.pressed:
			drawing = false
	
	if event is InputEventMouseMotion and drawing:
		image.set_pixel(event.position.x-1, event.position.y-1, color_picker_button.color)
		image.set_pixel(event.position.x, event.position.y-1, color_picker_button.color)
		image.set_pixel(event.position.x+1, event.position.y-1, color_picker_button.color)
		image.set_pixel(event.position.x-1, event.position.y, color_picker_button.color)
		image.set_pixel(event.position.x, event.position.y, color_picker_button.color)
		image.set_pixel(event.position.x+1, event.position.y, color_picker_button.color)
		image.set_pixel(event.position.x-1, event.position.y+1, color_picker_button.color)
		image.set_pixel(event.position.x, event.position.y+1, color_picker_button.color)
		image.set_pixel(event.position.x+1, event.position.y+1, color_picker_button.color)
		
		image_texture = ImageTexture.create_from_image(image)
		texture_rect.texture = image_texture


func clear():
	image = Image.create_empty(800, 600, false, Image.FORMAT_RGB8)
	# Устанавливаем фон белого цвета
	for x in range(800):
		for y in range(600):
			image.set_pixel(x, y, Color.WHITE)
	
	# Создаем текстуру из изображения
	image_texture = ImageTexture.create_from_image(image)
	
	texture_rect.texture = image_texture


func fill(start_x: int, start_y: int):
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


func _on_color_picker_button_popup_closed() -> void:
	fill_color = color_picker_button.color


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")

@onready var file_dialog: FileDialog = $FileDialog
func _on_button_3_pressed() -> void:
	file_dialog.popup()
	


func _on_file_dialog_file_selected(path: String) -> void:
	pass # Replace with function body.
