extends Node2D

var player_actors = preload("res://actors/player.tscn")
var player = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player == null:
		var new_obj = player_actors.instantiate()
		new_obj.position = position
		get_parent().add_child(new_obj)
		player = new_obj
