extends TextureButton

func _process(delta):
	if pressed:
		PlayerVars.crafting = false
		pressed = false