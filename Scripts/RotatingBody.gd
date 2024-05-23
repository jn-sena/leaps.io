extends KinematicBody2D

var proc = false

var t = null

func _ready():
	t = Timer.new()
	self.add_child(t)

func _process(delta):
	if not proc:
		proc = true
		rotation_degrees += 1
		t.set_wait_time(0.1)
		t.set_one_shot(true)
		t.start()
		yield(t, "timeout")
		proc = false