extends CharacterBody3D
enum States{
	walking,
	following,
	waiting
	}

var currentState : States
var navAgent : NavigationAgent3D
@export var waypoints : Array[Node]
var waypointIndex : int
@export var patrolspeed = 4
@onready var timer: Timer = $Timer
@onready var footstep_player: AudioStreamPlayer3D = $PigFootstepPlayer
@export var footstep_sounds: Array[AudioStream] = []
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player_leave: bool
var player
var footstep_timer = 0.0
var footstep_interval = 0.4 
var last_footstep_index = -1  


func _ready():
	currentState = States.walking
	navAgent = $NavigationAgent3D
	navAgent.set_target_position(waypoints[0].global_position)
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func _process(delta):
	match currentState:
		States.walking:
			if(navAgent.is_navigation_finished()):
				currentState = States.waiting
				timer.start()
				return
			MoveTowardPoint(delta, patrolspeed)
			footstep_timer += delta
			if footstep_timer >= footstep_interval:
				play_random_footstep_sound()
				footstep_timer = 0.0  
		States.following:
			if(navAgent.is_navigation_finished()):
				currentState = States.waiting
			navAgent.set_target_position(player.global_position)
			MoveTowardPoint(delta, patrolspeed)
			footstep_timer += delta
			if footstep_timer >= footstep_interval:
				play_random_footstep_sound()
				footstep_timer = 0.0
				
		States.waiting:
			pass

func faceDirection(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)

func MoveTowardPoint(delta, speed):
	var targetPos = navAgent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	velocity = direction * speed
	move_and_slide()
	if(player_leave):
		CheckForPlayer()

func CheckForPlayer():
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create($".".global_position, get_tree().get_nodes_in_group("Player")[0].global_position, 1, [self]))
	if(result["collider"].is_in_group("Player")):
		if player_leave == true:
			currentState = States.following

func _on_player_leave_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_leave = true
		currentState = States.following


func _on_player_enter_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_leave = false
		currentState = States.walking
		navAgent.set_target_position(waypoints[0].global_position)
		
func play_random_footstep_sound():
	if footstep_sounds.size() > 0:
		var random_index = randi() % footstep_sounds.size()
		
		# Ensure the new sound is not the same as the last one
		while random_index == last_footstep_index and footstep_sounds.size() > 1:
			random_index = randi() % footstep_sounds.size()

		last_footstep_index = random_index  # Store the index of the current sound
		footstep_player.stream = footstep_sounds[random_index]  # Set the selected sound
		footstep_player.play()  # Play the sound

func _on_timer_timeout() -> void:
	currentState = States.walking
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navAgent.set_target_position(waypoints[waypointIndex].global_position)
	
	
