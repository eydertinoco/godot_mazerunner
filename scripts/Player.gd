extends CharacterBody2D

var speed = 150.0
const stop = 0

@onready var animation := $AnimatedSprite2D as AnimatedSprite2D
@onready var collision := $CollisionShape2D as CollisionShape2D
@onready var remote_transform   := $RemoteTransform2D as RemoteTransform2D

# Get the gravity from the project settings to be synced with RigidBody nodes.

func get_input():
	var direction = Input.get_vector("mov_left", "mov_right", "mov_up", "mov_down")
	if direction:
		if direction.x > 0:
			animation.scale.x = 1
		elif direction.x < 0:
			animation.scale.x = -1
		velocity = direction * speed
		animation.play("running")
	else:
		velocity = direction * stop
		animation.play("idle")

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	move_and_slide()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		queue_free()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	elif body.is_in_group("debuff"):
		speed = speed - 10
		print(speed)
