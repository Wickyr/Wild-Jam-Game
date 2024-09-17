extends CSGBox3D

var toggle = true
var interactable = true
@onready var truffle: CSGBox3D = $"."

func interact():
	truffle.queue_free()
