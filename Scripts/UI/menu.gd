extends Control
@onready var menu: VBoxContainer = $MarginContainer/menu
@onready var settings: VBoxContainer = $MarginContainer/settings


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_setting_pressed():
	settings.visible = true
	menu.visible = false


func _on_quit_pressed():
	get_tree().quit()


func _on_back_pressed() -> void:
	settings.visible = false
	menu.visible = true
