extends Control
@onready var menu: VBoxContainer = $MarginContainer/menu
@onready var settings: VBoxContainer = $MarginContainer/settings
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	audio.play()


func _on_setting_pressed():
	settings.visible = true
	menu.visible = false
	audio.play()


func _on_quit_pressed():
	get_tree().quit()
	audio.play()


func _on_back_pressed() -> void:
	settings.visible = false
	menu.visible = true
	audio.play()
