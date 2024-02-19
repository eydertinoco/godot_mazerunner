extends Area2D

var is_active = false

func _on_area_2d_body_entered(_body):
	if (Globals.tesouroColetado == 1):
		get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
	else:
		print('Nada acontece')
