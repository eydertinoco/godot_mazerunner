extends Area2D

func _on_body_entered(_body):
	Globals.nivelJogo += 1
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
