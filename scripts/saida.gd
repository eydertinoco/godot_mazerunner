extends Node2D

func _on_body_entered(_body):
	Globals.nivelJogo += 1
	novoJogo()

func novoJogo():
	
