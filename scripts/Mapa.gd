extends TileMap

var ground_layer = 0
var wall_layer = 1

var width_map = 128
var height_map = 128

var cells = []
func _generationMaze():
	for x in range(width_map):
		for y in range(height_map):
			if x == 0 or x == width_map - 1 and y == 0 or y == height_map - 1:
				cells.append(Vector2(x,y))
