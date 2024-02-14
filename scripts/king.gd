extends CharacterBody2D

const speed = 20

@export var player: Node2D
@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _physics_process(_delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * speed
	if direction.x > 0:
		animation.flip_h = true
	else:
		animation.flip_h = false
	move_and_slide()

func makepath() -> void:
	nav_agent.target_position = player.global_position

func _on_timer_timeout():
	makepath()

func _ready():
	makepath()
