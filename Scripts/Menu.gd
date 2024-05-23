extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(ev):
	if ev.is_action_pressed("game_exec"):
		PlayerVars.loadGame()
		if PlayerVars.gtut:
			get_tree().change_scene("res://Scenes/TheMinusWorld.tscn")
		else:
			PlayerVars.otut = true
			PlayerVars.qopos = Vector2(1245.44, 8.192)
			get_tree().change_scene("res://Scenes/Tutorial.tscn")
			Engine.time_scale = 0.01
