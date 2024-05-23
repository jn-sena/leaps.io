extends TextureButton

func _process(delta):
	if PlayerVars.otut:
		pressed = false
		disabled = true
		visible = false
	else:
		disabled = false
		visible = true
	if pressed and not PlayerVars.otut:
		get_parent().get_node("SaveDeleted").visible = true
		var save_dict = {
		"finTut": false,
		"level": 1,
		"xp": 0,
		"pos_x": 0,
		"pos_y": 0,
		"items": [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]],
		"balance": 0,
		"skills": [0, 0, 0, 0]
		}
		var save_game = File.new()
		save_game.open("user://save0.sv", File.WRITE)
		save_game.store_line(to_json(save_dict))
		save_game.close()
		pressed = false