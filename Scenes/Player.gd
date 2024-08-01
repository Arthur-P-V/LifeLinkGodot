extends CharacterBody2D

enum States {Air = 1, Ground, Wall}
var state = States.Air
const SPEED = 150.0
const JUMP_VELOCITY = -400
const WALL_JUMP_VELOCITY = -450
const JUMP_PUSHBACK = 500
const FRICTION = 25.0
const FALL_GRAVITY = 1600

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var prev_wall_x = -1000000000


func _physics_process(delta):
	#Determine Direction of Input
	var direction = Input.get_axis("Left", "Right")
	
	if direction:
		$WallCheck.rotation = 90 * -direction
	
	#print(NearWall())
	# Add the gravity.
	velocity.y += GetGravity(velocity) * delta
	
	if direction:	#Horizontal Movement
		velocity.x = direction * SPEED
		
	match state:
		States.Air:
			
			if is_on_floor():
				prev_wall_x = -1000000000
				state = States.Ground
			
			if NearWall():
				state = States.Wall
				
			if Input.is_action_just_released("Jump") and velocity.y < 0: #This is to control jump height via release of jump key
				velocity.y = JUMP_VELOCITY / 4
			
			
		States.Ground:
			if not is_on_floor():
				state = States.Air
				
			if Input.is_action_just_pressed("Jump"): #Fairly obvious that this is handling jumping
				velocity.y = JUMP_VELOCITY
			
			if not direction:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				
				
		States.Wall:  #For later
			
			if is_on_floor_only():
				state = States.Ground
			if not NearWall() and not is_on_floor():
				state = States.Air
			
			if direction: 											#If the player presses against the wall
				velocity.y = move_toward(velocity.y, 75, FRICTION)  #If they press away from the wall they'll change state
				
			if Input.is_action_just_pressed("Jump") and not is_equal_approx(prev_wall_x, position.x):
				prev_wall_x = position.x
				velocity.y = WALL_JUMP_VELOCITY
				if direction:
					velocity.x = direction * (SPEED * 2)
			
	move_and_slide()

func NearWall():
	return $WallCheck.is_colliding()

func GetGravity(velocity : Vector2):
	if (velocity.y < 0):
		return gravity
	return FALL_GRAVITY
	
