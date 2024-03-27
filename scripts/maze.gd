extends Node2D

@onready var tilemap = $Mapa as TileMap
@onready var player := $Player as CharacterBody2D
@onready var camera := $Camera2D as Camera2D

var map_size = Vector2(16*Globals.nivelJogo, 8*Globals.nivelJogo)
const land_cap = 0.1

func _ready():
	generationMaze()
	player.follow_camera(camera)

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func generationMaze():
	var noise = FastNoiseLite.new()
	noise.seed = randi();
	
	#coordenada inicial do jogador (1,1)
	
	#var cells = []
	for x in range(map_size.x):
		for y in range(map_size.y):
			#Criando paredes no extremo do mapa
			if x == 0 or x == map_size.x - 1 or y == 0 or y == map_size.y - 1:
				tilemap.set_cell(0, Vector2(x,y), 2, Vector2(1,1))
			elif x >= 1 and x <= 2 and y >= 1 and y <=2:
				tilemap.set_cell(0, Vector2(x,y), 1, Vector2(4,3))
			else:
				var a = noise.get_noise_2d(x,y)
				print(a)
				if a < land_cap:
					tilemap.set_cell(0, Vector2(x,y), 1, Vector2(4,3))
				else:
					tilemap.set_cell(0, Vector2(x,y), 2, Vector2(1,1))
			regrasmapa(x, y)

func regrasmapa(x,y):
	var totalParedes = 0;
	var paredeBaixo = false
	var paredeCima = false
	var paredeDireita = false
	var paredeEsquerda = false
	print("(" + str(x) + "," + str(y) + ")")
	var terreno = tilemap.get_cell_atlas_coords(0, Vector2i(x,y))
	#if terreno.x == 1 and terreno.y == 1:
	#	print('Parede!')
	if terreno.x == 4 and terreno.y == 3:
		if tilemap.get_cell_atlas_coords(0, Vector2i(x+1,y)).x == 1:
			print('Vejo uma parede em baixo')
			paredeBaixo = true
			totalParedes += 1
		if tilemap.get_cell_atlas_coords(0, Vector2i(x-1,y)).x == 1:
			print('Vejo uma parede em cima')
			paredeCima = true
			totalParedes += 1
		if tilemap.get_cell_atlas_coords(0, Vector2i(x,y+1)).y == 1:
			print('Vejo uma parede na esquerda')
			paredeEsquerda = true
			totalParedes += 1
		if tilemap.get_cell_atlas_coords(0, Vector2i(x,y-1)).y == 1:
			print('Vejo uma parede na direita')
			paredeDireita = true
			totalParedes += 1
	
	if paredeBaixo and paredeCima and paredeEsquerda and paredeDireita:
		var direcao = randi() % 4  # Gera um número aleatório entre 0 e 3
		match direcao:
			0:
				print('Mover para baixo')
			1:
				print('Mover para cima')
			2:
				print('Mover para a esquerda')
			3:
				print('Mover para a direita')
