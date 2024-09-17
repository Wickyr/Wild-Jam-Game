extends CSGBox3D

@onready var truffle: CSGBox3D = $"."

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if Input.is_action_pressed("e"):
			truffle.queue_free()
