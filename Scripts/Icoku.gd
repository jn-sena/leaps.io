extends KinematicBody2D

var executing = false
var rd = 0

func _process(delta):
	if PlayerVars.bossDead:
		get_parent().remove_child(self)

func _physics_process(delta):
	if not executing:
		executing = true
		for i in range(30):
			rd += 0.1
			rotation_degrees += rd
			var ft = Timer.new()
			ft.set_wait_time(0.01)
			ft.set_one_shot(true)
			self.add_child(ft)
			ft.start()
			yield(ft, "timeout")
		var t = Timer.new()
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		rd = 0
		for i in range(30):
			rd += 0.1
			rotation_degrees -= rd
			var ft = Timer.new()
			ft.set_wait_time(0.01)
			ft.set_one_shot(true)
			self.add_child(ft)
			ft.start()
			yield(ft, "timeout")
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		rd = 0
		for i in range(120):
			rd += 0.1
			rotation_degrees -= rd
			var ft = Timer.new()
			ft.set_wait_time(0.01)
			ft.set_one_shot(true)
			self.add_child(ft)
			ft.start()
			yield(ft, "timeout")
		t.set_wait_time(0.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		rd = 0
		executing = false