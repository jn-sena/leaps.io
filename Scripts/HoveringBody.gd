extends KinematicBody2D

var do = false

var t = Timer.new()
var ft = Timer.new()

func _ready():
	self.add_child(t)
	self.add_child(ft)

func _physics_process(delta):
	if not do:
		do = true
		for i in range(10):
			position.y -= i / 3
			t.set_wait_time(0.001)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
		position.y -= 0.5
		ft.set_wait_time(0.001)
		ft.set_one_shot(true)
		ft.start()
		yield(ft, "timeout")
		for i in range(10):
			position.y += i / 3
			t.set_wait_time(0.001)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
		position.y += 0.5
		ft.set_wait_time(0.001)
		ft.set_one_shot(true)
		ft.start()
		yield(ft, "timeout")
		do = false

var ihelmet = preload("res://Assets/Items/helmet.png")

func _process(delta):
	if PlayerVars.helmet == 0:
		get_node("Helmet").visible = false
		get_node("Helmet").texture = null
	if PlayerVars.helmet == 1:
		get_node("Helmet").visible = true
		get_node("Helmet").set_texture(ihelmet)