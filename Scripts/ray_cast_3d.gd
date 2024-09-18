extends RayCast3D

func _process(delta):
	if is_colliding():
		var hitObj = get_collider()
		if hitObj and hitObj.has_method("interact"): 
			if Input.is_action_just_pressed("e"):
				hitObj.interact()
