extends Node

var bosslife := 3
var lama := -10
var entrarDungeon := false

var nivelJogo := 2

var tesouroColetado := 0

var exit

var player = null
var home = null

var initial_player_position = null

func spawnPlayer():
	if initial_player_position != null:
		player.position = initial_player_position.global_position
