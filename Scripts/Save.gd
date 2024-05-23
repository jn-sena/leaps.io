extends TextureProgress

export (bool) var proc = false
export (bool) var rev = false

func _ready():
	visible = false

func _process(delta):
	if visible == true and proc == false:
		proc = true
		PlayerVars.saving = true
		for i in range(135):
			if value <= 0:
				rev = false
			elif value >= 100:
				rev = true
			if rev == false:
				value += 10
			if rev == true:
				value -= 10
			var t = Timer.new()
			t.set_wait_time((delta / 2) * Engine.time_scale)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
		visible = false
		PlayerVars.saving = false
		proc = false