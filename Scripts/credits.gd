extends Node3D
@onready var timer: Timer = $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("space"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
