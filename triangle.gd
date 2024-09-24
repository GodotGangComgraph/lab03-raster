extends Control


@onready var texture_rect: TextureRect = $TextureRect

@onready var vertex_1: Button = $Vertex1
@onready var vertex_2: Button = $Vertex2
@onready var vertex_3: Button = $Vertex3

@export var color_1 = Color(1, 0, 0)
@export var color_2 = Color(0, 1, 0)
@export var color_3 = Color(0, 0, 1)


func _ready():
	draw_triangle()


func draw_triangle():
	var min_x = min(vertex_1.position.x, vertex_2.position.x, vertex_3.position.x)
	var min_y = min(vertex_1.position.y, vertex_2.position.y, vertex_3.position.y)
	var max_x = max(vertex_1.position.x, vertex_2.position.x, vertex_3.position.x)
	var max_y = max(vertex_1.position.y, vertex_2.position.y, vertex_3.position.y)
	
	var image = Image.new()
	image = Image.create_empty(max_x+1, max_y+1, false, Image.FORMAT_RGBA8)
	
	
	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var p = Vector2(x, y)
			
			var lambda1 = ((vertex_2.position.y - vertex_3.position.y) * (p.x - vertex_3.position.x) \
			+ (vertex_3.position.x - vertex_2.position.x) * (p.y - vertex_3.position.y)) / ((vertex_2.position.y - vertex_3.position.y) \
			* (vertex_1.position.x - vertex_3.position.x) + (vertex_3.position.x - vertex_2.position.x) * (vertex_1.position.y - vertex_3.position.y))
			
			var lambda2 = ((vertex_3.position.y - vertex_1.position.y) * (p.x - vertex_3.position.x) \
			+ (vertex_1.position.x - vertex_3.position.x) * (p.y - vertex_3.position.y)) / ((vertex_2.position.y - vertex_3.position.y) \
			* (vertex_1.position.x - vertex_3.position.x) + (vertex_3.position.x - vertex_2.position.x) * (vertex_1.position.y - vertex_3.position.y))
			
			var lambda3 = 1.0 - lambda1 - lambda2
			
			if lambda1 >= 0 and lambda2 >= 0 and lambda3 >= 0:
				var interpolated_color = color_1 * lambda1 + color_2 * lambda2 + color_3 * lambda3
				image.set_pixel(x, y, interpolated_color)
	
	var texture = ImageTexture.create_from_image(image)
	texture_rect.texture = texture


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
