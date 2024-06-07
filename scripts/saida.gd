extends Area2D

func _on_body_entered(_body):
	print('Entrou na saida')
	Globals.nivelJogo += 1

