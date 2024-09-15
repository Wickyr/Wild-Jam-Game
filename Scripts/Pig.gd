extends CharacterBody3D
enum States{
	walking,
	waiting
	}

var currentState : States
var navAgent : NavigationAgent3D
@export var waypoints : Array[Node]
var waypointIndex : int
@export var patrolspeed = 4
@onready var timer: Timer = $Timer
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	currentState = States.walking
	navAgent = $NavigationAgent3D
	navAgent.set_target_position(waypoints[0].global_position)

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
