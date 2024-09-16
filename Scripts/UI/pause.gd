extends MarginContainer

@onready var menu: VBoxContainer = $menu
@onready var settings: VBoxContainer = $settings
@onready var pause_menu: CanvasLayer = $".."
@onready var player: CharacterBody3D = $"../../Player"


func _process(delta: float) -> void:
	if Input.is_action_pressed("quit"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_menu.visible = true
		Engine.time_scale = 0
		player.mouse_sens = 0

func _on_setting_pressed() -> void:
	menu.visible = false
	settings.visible = true


func _on_back_pressed() -> void:
	menu.visible = true
	settings.visible = false


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause_menu.visible = false
	Engine.time_scale = 1
	player.mouse_sens = 0.2
