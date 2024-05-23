extends KinematicBody2D

func hit():
	if PlayerVars.sword > 0:
		get_node("CollisionPolygon2D").disabled = false
		get_node("CPUParticles2D").emitting = true
		for i in range(9):
			var t = Timer.new()
			t.set_wait_time(0.0001)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			rotation_degrees += 4.1
		for i in range(9):
			var t = Timer.new()
			t.set_wait_time(0.0001)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			rotation_degrees -= 4.1
		get_node("CollisionPolygon2D").disabled = true
		get_node("CPUParticles2D").visible = false
		get_node("CPUParticles2D").emitting = false
		get_node("CPUParticles2D").visible = true

func _process(delta):
	if PlayerVars.sword <= 0:
		get_node("CollisionPolygon2D").disabled = true
		visible = false
	else:
		visible = true