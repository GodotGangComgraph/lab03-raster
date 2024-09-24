extends Control


func _on_lines_pressed() -> void:
	get_tree().change_scene_to_file("res://bresenham.tscn")


func _on_triangle_pressed() -> void:
	get_tree().change_scene_to_file("res://triangle.tscn")


func _on_fill_pressed() -> void:
	get_tree().change_scene_to_file("res://filling.tscn")


func _on_border_pressed() -> void:
	get_tree().change_scene_to_file("res://border.tscn")
