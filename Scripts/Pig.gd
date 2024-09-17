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
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player_leave: bool
var player


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
		States.following:
			if(navAgent.is_navigation_finished()):
				currentState = States.waiting
			navAgent.set_target_position(player.global_position)
			MoveTowardPoint(delta, patrolspeed)
		States.waiting:
			pass
		
	if player_leave == true:
		currentState = States.following
	if player_leave == false:
		currentState = States.walking

func faceDirection(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)

func MoveTowardPoint(delta, speed):
	var targetPos = navAgent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	velocity = direction * speed
	move_and_slide()


func _on_player_leave_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_leave = true


func _on_player_enter_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_leave = false


func _on_timer_timeout() -> void:
	currentState = States.walking
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navAgent.set_target_position(waypoints[waypointIndex].global_position)
