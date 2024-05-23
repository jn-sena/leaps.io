extends Control

var t = Timer.new()
var ct = Timer.new()
var er = false
var pproc = false

func _ready():
	self.add_child(t)
	self.add_child(ct)

func _process(delta):
	get_node("HealthBar/Progress").value = PlayerVars.Health
	get_node("StaminaBar/Progress").value = PlayerVars.Stamina
	get_node("XPBar/Progress").value = PlayerVars.xp
	get_node("XPBar/LevelProgress").value = PlayerVars.level
	if PlayerVars.crafting and not pproc:
		pproc = true
		for i in range(10):
			self.modulate.a -= 0.1
		self.modulate.a = 0
		pproc = false
	else:
		pproc = false
		self.modulate.a = 1
	if not get_node("LastIt").texture == null and not er:
		er = true
		for i in range(100):
			if get_node("LastIt").modulate.a <= 0:
				break
			get_node("LastIt").modulate.a -= 0.05
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
		er = false
		get_node("LastIt").texture = null
		get_node("LastIt").modulate.a = 1