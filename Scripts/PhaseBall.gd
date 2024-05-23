extends KinematicBody2D

func hit():
	get_parent().remove_child(self)
	PlayerVars.bossDead = true
	PlayerVars.gtut = true
	PlayerVars.qopos = Vector2(1379.718, -502.84)
	PlayerVars.pos = Vector2(430.913, 265.83)
	PlayerVars.fplay = true
	PlayerVars.saveGame()

func _physics_process(delta):
	rotation_degrees += 1