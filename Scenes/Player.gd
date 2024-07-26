extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -275.0
const JUMP_PUSHBACK = 1000
const FRICTION = 25.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var prev_wall_x = -1000000000


func _physics_process(delta):
	#Determine Direction of Input
	var direction = Input.get_axis("Left", "Right")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		prev_wall_x = -1000000000
		
	if is_on_wall_only():
		velocity.y = move_toward(velocity.y, 75, FRICTION)

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		Jump()
	
	if Input.is_action_just_pressed("Jump") and is_on_wall_only():
		Wall_Jump(direction)
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func Jump():
	velocity.y = JUMP_VELOCITY
	
func Wall_Jump(dir):
	print(prev_wall_x)
	print(position.x)
	if(snapped(position.x, 0) != prev_wall_x):
		prev_wall_x = snapped(position.x, 0)
		Jump()
		#velocity.x = JUMP_PUSHBACK
