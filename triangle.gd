extends Control


@onready var texture_rect: TextureRect = $TextureRect

@onready var vertex_1: Button = $Vertex1
@onready var vertex_2: Button = $Vertex2
@onready var vertex_3: Button = $Vertex3


@export var colors = [
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(0, 0, 1)
]


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
				var interpolated_color = colors[0] * lambda1 + colors[1] * lambda2 + colors[2] * lambda3
				image.set_pixel(x, y, interpolated_color)
	
	var texture = ImageTexture.create_from_image(image)
	texture_rect.texture = texture
