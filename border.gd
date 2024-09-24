extends Control

var image : Image
var boundary_color : Color = Color.BLACK
var start_point : Vector2
var boundary_points : Array = []
var draw_color: Color
@onready var color_picker_button: ColorPickerButton = $VBoxContainer/MarginContainer/HBoxContainer/ColorPickerButton
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var file_dialog: FileDialog = $FileDialog
var image_path

func draw_boundary():
	draw_color = color_picker_button.color
	image = Image.load_from_file(image_path)
	
	start_point = find_boundary_start()

	if start_point:
		follow_boundary(start_point)
	queue_redraw()

func find_boundary_start() -> Vector2:
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var pixel_color = image.get_pixel(x, y)
			if pixel_color == boundary_color:
				return Vector2(x, y)
	return Vector2(0, 0)


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
				if next_point in boundary_points:
					return
				boundary_points.append(next_point)
				#var lambda = func(vec: Vector2, vec2: Vector2):
				#	return vec[1] < vec2[1] or vec[0] < vec2[0]
				# boundary_points.sort_custom(lambda)
				current_point = next_point
				found_next = true
				current_direction = (direction_index + 6) % 8 # Поворот на 90 градусов по часовой
				break
		
		if not found_next:
			break

func _draw():
	for point in boundary_points:
		draw_circle(point, 1, draw_color)
	draw_texture_rect(ImageTexture.create_from_image(image), texture_rect.get_rect(), false)


func _on_color_picker_button_color_changed(color: Color) -> void:
	draw_color = color
	queue_redraw()


func _on_button_pressed() -> void:
	file_dialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	boundary_points.clear()
	queue_redraw()
	image_path = path
	draw_boundary()
