extends MarginContainer

func _process(delta):
	get_node("Progress").max_value = PlayerVars.MaxHealth