extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(ev):
	if ev.is_action_pressed("ui_fullscreen"):
		OS.window_fullscreen = true
		get_tree().change_scene("res://Scenes/Menu.tscn")