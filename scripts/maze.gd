# (BFS - Breadth-First Search) para garantir que a saída seja acessível a partir do ponto de partida do jogador.

extends Node2D

@onready var tilemap = $Mapa as TileMap
@onready var player := $Player as CharacterBody2D
@onready var player_scene = preload("res://actors/player.tscn")
@onready var hunter_scene = preload("res://actors/hunter.tscn")
@onready var camera := $Camera2D as Camera2D
@onready var saida := $Saida as Area2D

var map_size = Vector2(16*Globals.nivelJogo, 8*Globals.nivelJogo)
# Matriz para representar o labirinto
var maze = [] 
# Matriz para acompanhar as células visitadas
var visited = [] 
# Posição inicial do jogador
var player_start = Vector2(1, 1) 
# Posição de saída do labirinto
#var exit_point = Vector2((16*Globals.nivelJogo)-1, (8*Globals.nivelJogo)-1)
var exit_point = Vector2(randi() % int(map_size.x), randi() % int(map_size.y))

func _ready():
	Globals.player = player
	Globals.player.follow_camera(camera)
	initialize_maze()
	generate_maze()
	connect_start_to_exit()
	place_hunter()
	display_maze()

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

# Inicialização do labirinto
func initialize_maze():
	maze.clear()
	visited.clear()
	# É gerado a estrutura do labirinto.
	for x in range(map_size.x):
		var row = []
		var visited_row = []
		for y in range(map_size.y):
			row.append(1) # Todas as células começam como paredes
			visited_row.append(false) # Todas as células são marcadas como não visitadas
		maze.append(row)
		visited.append(visited_row)
	#print('Mapa do labrinto ao ser inicializado:')
	#print(maze)

# Gerar labirinto
func generate_maze():
	# Pilha para acompanhar as células visitadas
	var stack = []
	# Célula inicial aleatória
	var current_cell = Vector2(randi() % int(map_size.x), randi() % int(map_size.y))
	# var current_cell = player_start
	visited[current_cell.x][current_cell.y] = true
	while has_unvisited_cells():
		# Observa os campos ao redor dele
		var neighbors = get_unvisited_neighbors(current_cell)
		if neighbors.size() > 0:
			var next_cell = neighbors[randi() % neighbors.size()]
			remove_wall(current_cell, next_cell)
			stack.append(current_cell)
			current_cell = next_cell
			visited[current_cell.x][current_cell.y] = true
		elif stack.size() > 0:
			# Não há mais caminho, ele retorna para campo anterior.
			current_cell = stack.pop_back()
	#print('Mapa Gerado')
	#print(maze)

# Essa função vai procurar por coordenadas que não foram visitadas
func has_unvisited_cells():
	for x in range(map_size.x):
		for y in range(map_size.y):
			if !visited[x][y]:
				return true
	return false

# Visitar todas coordenadas vizinhas da celula
func get_unvisited_neighbors(cell):
	var neighbors = []
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	for dir in directions:
		var neighbor = cell + dir
		if neighbor.x >= 0 and neighbor.x < map_size.x and neighbor.y >= 0 and neighbor.y < map_size.y:
			if !visited[neighbor.x][neighbor.y]:
				neighbors.append(neighbor)
	return neighbors

# Conectar o começo ao fim
func connect_start_to_exit():
	var start_cell = player_start
	# Ajustando para as coordenadas do labirinto gerado
	#var exit_cell = Vector2(exit_point.x - 1, exit_point.y - 1) 
	# Célula inicial aleatória
	var exit_cell = exit_point
	# Use BFS para encontrar um caminho do início até a saída
	var fila = []
	var visited_cells = {}
	var parent_map = {}
	fila.append(start_cell)
	visited_cells[start_cell] = true
	while fila:
		var current = fila.pop_front()
		#print('fila: ' + str(fila))
		#print('Current: ' + str(current))
		if current == exit_cell:
			# Construa o caminho a partir dos parentes
			var path = []
			var node = exit_cell
			while node in parent_map:
				path.append(node)
				node = parent_map[node]
			# Adicione a célula inicial ao caminho
			path.append(start_cell) 
			# Reverter o caminho para começar do início
			path.reverse()
			# Remova as paredes entre o caminho
			for i in range(path.size() - 1):
				#print('Removendo parede [' + str(path[i]) + ',' + str(path[i+1]) + ']' )
				remove_wall2(path[i], path[i + 1])
			return
		var neighbors = get_adjacent_cells(current)
		for neighbor in neighbors:
			if neighbor not in visited_cells:
				fila.append(neighbor)
				visited_cells[neighbor] = true
				parent_map[neighbor] = current

func get_adjacent_cells(cell):
	var neighbors = []
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	for dir in directions:
		var neighbor = cell + dir
		if neighbor.x >= 0 and neighbor.x < map_size.x and neighbor.y >= 0 and neighbor.y < map_size.y:
			neighbors.append(neighbor)
	return neighbors

# Adicionando Muros
func remove_wall(cell1, cell2):
	# Pega a diferença entre as duas celulas adquiridas
	var diff = cell2 - cell1
	if diff == Vector2(1, 0): # Direita
		if cell1.x * 2 + 1 < maze.size() and cell1.y * 2 < maze[0].size():
			maze[cell1.x * 2 + 1][cell1.y * 2] = 0
	elif diff == Vector2(-1, 0): # Esquerda
		if cell2.x * 2 + 1 < maze.size() and cell2.y * 2 < maze[0].size():
			maze[cell2.x * 2 + 1][cell2.y * 2] = 0
	elif diff == Vector2(0, 1): # Baixo
		if cell1.x * 2 < maze.size() and cell1.y * 2 + 1 < maze[0].size():
			maze[cell1.x * 2][cell1.y * 2 + 1] = 0
	elif diff == Vector2(0, -1): # Cima
		if cell2.x * 2 < maze.size() and cell2.y * 2 + 1 < maze[0].size():
			maze[cell2.x * 2][cell2.y * 2 + 1] = 0

# Removendo muro fazendo ligação entre o começo e a saida
func remove_wall2(cell1, cell2):
	# Pega a diferença entre as duas celulas adquiridas
	var diff = cell2 - cell1
	if diff == Vector2(1, 0): # Direita
		if cell1.x + 1 < maze.size() and cell1.y < maze[0].size():
			maze[cell1.x + 1][cell1.y] = 1
	elif diff == Vector2(-1, 0): # Esquerda
		if cell2.x + 1 < maze.size() and cell2.y < maze[0].size():
			maze[cell2.x + 1][cell2.y] = 1
	elif diff == Vector2(0, 1): # Baixo
		if cell1.x < maze.size() and cell1.y + 1 < maze[0].size():
			maze[cell1.x][cell1.y + 1] = 1
	elif diff == Vector2(0, -1): # Cima
		if cell2.x < maze.size() and cell2.y + 1 < maze[0].size():
			maze[cell2.x][cell2.y + 1] = 1

func place_hunter():
	var hunter = hunter_scene.instantiate()
	add_child(hunter)
	hunter.player = player
	var placed = false
	while not placed:
		var x = randi() % int(map_size.x)
		var y = randi() % int(map_size.y)
		# Verifica se é um espaço vazio e diferente do player
		if maze[x][y] == 0 and Vector2(x, y) != player_start:
			hunter.position = Vector2(x * 16, y * 16)
			placed = true

# Construção do labirinto com tilemap
func display_maze():
	for x in range(map_size.x):
		for y in range(map_size.y):
			if x < maze.size() and y < maze[0].size():
				# Adicionar chão
				if maze[x][y] == 1:
					tilemap.set_cell(0, Vector2(x,y), 1, Vector2(4,3))
				# Adicionar Parede
				else:
					tilemap.set_cell(0, Vector2(x,y), 2, Vector2(1,1))
			if x == player_start.x and y == player_start.y:
				tilemap.set_cell(0, Vector2(x,y), 2, Vector2(7,1))
			# Criando paredes no extremo do mapa
			if x == 0 or x == map_size.x - 1 or y == 0 or y == map_size.y - 1:
				tilemap.set_cell(0, Vector2(x,y), 2, Vector2(1,1))
			# Criando saida
			if x == exit_point.x-1 and y == exit_point.y-1:
				tilemap.set_cell(0, Vector2(x,y), 2, Vector2(7,1))
				saida.position =  Vector2(((16 * (exit_point.x-1))) + 3, ((16 * (exit_point.y-1))) + 3)
