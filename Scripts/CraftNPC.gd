extends KinematicBody2D

var do = false

var t = Timer.new()
var ft = Timer.new()

var wring = false
var skip = false
var wred = false
var currdi = 0
var ting = false

func say(msg):
	if not get_node("Talk").text == msg:
		get_node("Talk").text = ""
		wring = true
		for i in range(msg.length()):
			if skip:
				skip = false
				break
			var tim = Timer.new()
			tim.set_wait_time(0.00075)
			tim.set_one_shot(true)
			self.add_child(tim)
			tim.start()
			yield(tim, "timeout")
			get_node("Talk").text = get_node("Talk").text + msg[i]
		get_node("Talk").text = msg
		wring = false

func talk():
	ting = true
	PlayerVars.odialog = true

func _ready():
	self.add_child(t)
	self.add_child(ft)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_pause"):
		skip = true
	if skip and not wring:
		skip = false
		currdi += 1
	if ting:
		if not wring:
			if currdi == 0:
				say("What you want to craft today?")
		if currdi >= 1:
			PlayerVars.odialog = false
			ting = false
			currdi = 0
			PlayerVars.crafting = true
	var trad = (get_node("Talk").text.length()) * 8
	var brad = (get_node("Talk").text.length()) * 7
	get_node("TalkBalloon").mesh.top_radius = trad
	get_node("TalkBalloon").mesh.bottom_radius = brad
	if PlayerVars.odialog:
		get_node("TalkBalloon").visible = true
		get_node("Talk").visible = true
	else:
		get_node("TalkBalloon").visible = false
		get_node("Talk").visible = false

func _physics_process(delta):
	if not do:
		do = true
		for i in range(10):
			position.y -= i / 4
			t.set_wait_time(0.01)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
		position.y -= 0.5
		ft.set_wait_time(0.01)
		ft.set_one_shot(true)
		ft.start()
		yield(ft, "timeout")
		for i in range(10):
			position.y += i / 4
			t.set_wait_time(0.01)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
		position.y += 0.5
		ft.set_wait_time(0.01)
		ft.set_one_shot(true)
		ft.start()
		yield(ft, "timeout")
		do = false