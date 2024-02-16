extends Area2D

var tesouroFechado = true
@onready var animation := $AnimatedSprite2D as AnimatedSprite2D

func _on_body_entered(body):
	if (tesouroFechado):
		Globals.tesouroColetado = Globals.tesouroColetado + 1
		print('Adquirido 1 moeda')
		print(Globals.tesouroColetado)
		animation.play('opened')
		tesouroFechado = false
	else:
		print('Já pegou o tesouro')
		print(Globals.tesouroColetado)
