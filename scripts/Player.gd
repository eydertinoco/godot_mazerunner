extends CharacterBody2D

const speed = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.

func get_input():
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	#velocity = input_direction * speed
	var direction = Input.get_vector("mov_left", "mov_right", "mov_up", "mov_down")
	velocity = direction * speed

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	move_and_slide()
