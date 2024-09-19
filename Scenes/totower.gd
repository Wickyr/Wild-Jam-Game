extends CSGBox3D

var toggle = false
var interactable = true

func interact():
	get_tree().change_scene_to_file("res://Scenes/towernight.tscn")
