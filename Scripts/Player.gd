extends CharacterBody3D

@export var current_speed = 5.0
@export var walk_speed = 5.0
@export var run_speed = 8.0

@export var mouse_sens = 0.2
@onready var head = $Head
@onready var pause_menu: CanvasLayer = $"../PauseMenu"
@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer

# Array to hold footstep audio streams
@export var footstep_sounds: Array[AudioStream] = []

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_moving = false
var footstep_timer = 0.0
var footstep_interval = 0.5  # Default interval in seconds
var last_footstep_index = -1  # Track the last footstep sound index

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if Input.is_action_pressed("sprint"):
		current_speed = run_speed
	else:
		current_speed = walk_speed

	# Update the footstep interval based on current speed
	footstep_interval = 1.5 / current_speed  # Adjust as needed for more natural intervals
			
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		if not is_moving:
			is_moving = true
		footstep_timer += delta  # Increment the timer
		if footstep_timer >= footstep_interval:
			play_random_footstep_sound()
			footstep_timer = 0.0  # Reset the timer
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		is_moving = false

	move_and_slide()

func play_random_footstep_sound():
	if footstep_sounds.size() > 0:
		var random_index = randi() % footstep_sounds.size()
		
		# Ensure the new sound is not the same as the last one
		while random_index == last_footstep_index and footstep_sounds.size() > 1:
			random_index = randi() % footstep_sounds.size()

		last_footstep_index = random_index  # Store the index of the current sound
		footstep_player.stream = footstep_sounds[random_index]  # Set the selected sound
		footstep_player.play()  # Play the sound
