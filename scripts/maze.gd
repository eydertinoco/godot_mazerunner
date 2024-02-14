extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var camera := $Camera2D as Camera2D

func _ready():
	player.follow_camera(camera)

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

