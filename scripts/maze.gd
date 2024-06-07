extends Node2D

@onready var tilemap = $Mapa as TileMap
@onready var player := $Player as CharacterBody2D
@onready var player_scene = preload("res://actors/player.tscn")
@onready var camera := $Camera2D as Camera2D
@onready var saida := $Saida as Area2D


var map_size = Vector2(16*Globals.nivelJogo, 8*Globals.nivelJogo)
var maze = [] # Matriz para representar o labirinto
var visited = [] # Matriz para acompanhar as células visitadas

var player_start = Vector2(1, 1) # Posição inicial do jogador
var exit_point = Vector2((16*Globals.nivelJogo)-1, (8*Globals.nivelJogo)-1) # Posição de saída do labirinto


func _ready():
	Globals.player = player
	Globals.player.follow_camera(camera)
	initialize_maze()
	generate_maze()
	remove_random_wall_at_end_of_maze()
	display_maze()

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func initialize_maze():
	for x in range(map_size.x):
		var row = []
		var visited_row = []
		for y in range(map_size.y):
			row.append(1) # Todas as células começam como paredes
			visited_row.append(false) # Todas as células são marcadas como não visitadas
		maze.append(row)
		visited.append(visited_row)

func generate_maze():
	var stack = [] # Pilha para acompanhar as células visitadas
	var current_cell = Vector2(randi() % int(map_size.x), randi() % int(map_size.y)) # Célula inicial aleatória
	visited[current_cell.x][current_cell.y] = true

	while has_unvisited_cells():
		var neighbors = get_unvisited_neighbors(current_cell)
		if neighbors.size() > 0:
			var next_cell = neighbors[randi() % neighbors.size()]
			remove_wall(current_cell, next_cell)
			stack.append(current_cell)
			current_cell = next_cell
			visited[current_cell.x][current_cell.y] = true
		elif stack.size() > 0:
			current_cell = stack.pop_back()

func has_unvisited_cells():
	for x in range(map_size.x):
		for y in range(map_size.y):
			if !visited[x][y]:
				return true
	return false

func get_unvisited_neighbors(cell):
	var neighbors = []
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	for dir in directions:
		var neighbor = cell + dir
		if neighbor.x >= 0 and neighbor.x < map_size.x and neighbor.y >= 0 and neighbor.y < map_size.y:
			if !visited[neighbor.x][neighbor.y]:
				neighbors.append(neighbor)
	return neighbors

func remove_wall(cell1, cell2):
	var diff = cell2 - cell1
	if diff.x == 1: # Direita
		if cell1.x * 2 + 1 < maze.size() and cell1.y * 2 < maze[0].size():
			maze[cell1.x * 2 + 1][cell1.y * 2] = 0
	elif diff.x == -1: # Esquerda
		if cell2.x * 2 + 1 < maze.size() and cell2.y * 2 < maze[0].size():
			maze[cell2.x * 2 + 1][cell2.y * 2] = 0
	elif diff.y == 1: # Baixo
		if cell1.x * 2 < maze.size() and cell1.y * 2 + 1 < maze[0].size():
			maze[cell1.x * 2][cell1.y * 2 + 1] = 0
	elif diff.y == -1: # Cima
		if cell2.x * 2 < maze.size() and cell2.y * 2 + 1 < maze[0].size():
			maze[cell2.x * 2][cell2.y * 2 + 1] = 0

func remove_random_wall_at_end_of_maze():
	var end_cell = Vector2(map_size.x - 1, map_size.y - 1) # Célula final do labirinto
	var neighbors = []
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	for dir in directions:
		var neighbor = end_cell + dir
		if neighbor.x >= 0 and neighbor.x < map_size.x and neighbor.y >= 0 and neighbor.y < map_size.y:
			neighbors.append(neighbor)
	var random_neighbor = neighbors[randi() % neighbors.size()]
	remove_wall(end_cell, random_neighbor)

func display_maze():
	for x in range(map_size.x * 2 + 1):
		for y in range(map_size.y * 2 + 1):
			if x < maze.size() and y < maze[0].size():
				if maze[x][y] == 1:
					tilemap.set_cell(0, Vector2(x,y), 1, Vector2(4,3))
				else:
					tilemap.set_cell(0, Vector2(x,y), 2, Vector2(1,1))
		print()
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			#Criando paredes no extremo do mapa
			if x == 0 or x == map_size.x - 1 or y == 0 or y == map_size.y - 1:
				tilemap.set_cell(0, Vector2(x,y), 2, Vector2(1,1))
			elif x == player_start.x and y == player_start.y:
				tilemap.set_cell(0, Vector2(x,y), 1, Vector2(4,3))
			elif x == exit_point.x-1 and y == exit_point.y-1:
				tilemap.set_cell(0, Vector2(x,y), 2, Vector2(7,1))
				saida.position =  Vector2(((16 * (exit_point.x-1))) + 3, ((16 * (exit_point.y-1))) + 3)
				print(saida.position)
