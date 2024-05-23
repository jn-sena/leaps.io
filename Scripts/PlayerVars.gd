extends Node

var qopos = Vector2(0, 0)
var pos = Vector2(0, 0)
var gpos = Vector2(0, 0)
var Stamina = 100
var MaxHealth = 100
var Health = 100
var balance = 0
var stcool = false
var xp = 0
var level = 1
var paused = false
var gtut = false
var otut = false
var fplay = false
var bossDead = false
var inventory = false
var ianim = false
var helmet = 0
var items = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
var isid = 0
var skills = [0, 0, 0, 0]
var scooldown = [100, 100, 100, 100]
var sproc = [0, 0, 0, 0]
var dexec = false
var sword = 0
var dialog = false
var saving = false
var odialog = false
var crafting = false

func _ready():
	OS.set_low_processor_usage_mode(true)

func staminaRegen(speed):
	PlayerVars.stcool = true
	var tt = Timer.new()
	tt.set_wait_time(4)
	tt.set_one_shot(true)
	self.add_child(tt)
	tt.start()
	yield(tt, "timeout")
	PlayerVars.stcool = false
	if PlayerVars.stcool:
		return
	for i in range(100):
		if PlayerVars.stcool:
			return
		if PlayerVars.Stamina >= 100:
			return
		var t = Timer.new()
		t.set_wait_time(0.2)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		PlayerVars.Stamina += speed

func save():
	var save_dict = {
		"finTut": PlayerVars.gtut,
		"firstPlay": PlayerVars.fplay,
		"level": PlayerVars.level,
		"xp": PlayerVars.xp,
		"pos_x": PlayerVars.pos.x,
		"pos_y": PlayerVars.pos.y,
		"items": PlayerVars.items,
		"balance": PlayerVars.balance,
		"skills": PlayerVars.skills,
		"objective_pos_x": PlayerVars.qopos.x,
		"objective_pos_y": PlayerVars.qopos.y
	}
	return save_dict

func saveGame():
	var save_game = File.new()
	save_game.open("user://save0.sv", File.WRITE)
	save_game.store_line(to_json(save()))
	save_game.close()

func loadGame():
	var save_game = File.new()
	if not save_game.file_exists("user://save0.sv"):
		return
	save_game.open("user://save0.sv", File.READ)
	var current_line = parse_json(save_game.get_line())
	PlayerVars.gtut = current_line["finTut"]
	PlayerVars.level = current_line["level"]
	PlayerVars.xp = current_line["xp"]
	PlayerVars.pos = Vector2(current_line["pos_x"], current_line["pos_y"])
	PlayerVars.items = current_line["items"]
	PlayerVars.balance = current_line["balance"]
	PlayerVars.skills = current_line["skills"]
	PlayerVars.qopos = Vector2(current_line["objective_pos_x"], current_line["objective_pos_y"])
	PlayerVars.fplay = current_line["firstPlay"]
	save_game.close()

func _process(delta):
	PlayerVars.Health += 0.01
	if PlayerVars.helmet == 0:
		PlayerVars.MaxHealth = 100
	elif PlayerVars.helmet == 1:
		PlayerVars.MaxHealth = 125
	if PlayerVars.Stamina > 100:
		PlayerVars.Stamina = 100
	elif PlayerVars.Stamina < 0:
		PlayerVars.Stamina = 0
	if PlayerVars.Health > PlayerVars.MaxHealth:
		PlayerVars.Health = PlayerVars.MaxHealth
	elif PlayerVars.Stamina < 0:
		PlayerVars.Stamina = 0
	if PlayerVars.level >= 11:
		PlayerVars.xp = 249
	if PlayerVars.xp >= 250:
		PlayerVars.xp = 249
		for i in range(10):
			PlayerVars.xp -= 25
			if PlayerVars.xp <= 0:
				break
			var t = Timer.new()
			t.set_wait_time(0.01)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
		for i in range(10):
			PlayerVars.level += 0.1
			var t = Timer.new()
			t.set_wait_time(0.01)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
	for i in range(4):
		var xd = i - 1
		if PlayerVars.scooldown[xd] < 0:
			PlayerVars.scooldown[xd] = 0
		elif PlayerVars.scooldown[xd] > 100:
			PlayerVars.scooldown[xd] = 100
	if PlayerVars.scooldown[0] < 100 and sproc[0] == 0:
		sproc[0] = 1
	if sproc[0] == 1:
		sproc[0] = 2
		for i in range(15):
			var t = Timer.new()
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			PlayerVars.scooldown[0] += 7
			if PlayerVars.scooldown[0] >= 100:
				PlayerVars.scooldown[0] = 100
				break
		sproc[0] = 0
	if PlayerVars.scooldown[1] < 100 and sproc[1] == 0:
		sproc[1] = 1
	if sproc[1] == 1:
		sproc[1] = 2
		for i in range(50):
			var t = Timer.new()
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			PlayerVars.scooldown[1] += 2
			if PlayerVars.scooldown[1] >= 100:
				PlayerVars.scooldown[1] = 100
				break
		sproc[1] = 0
	if PlayerVars.scooldown[2] < 100 and sproc[2] == 0:
		sproc[2] = 1
	if sproc[2] == 1:
		sproc[2] = 2
		for i in range(100):
			var t = Timer.new()
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			PlayerVars.scooldown[2] += 1
			if PlayerVars.scooldown[2] >= 100:
				PlayerVars.scooldown[2] = 100
				break
		sproc[2] = 0
	if PlayerVars.scooldown[3] < 100 and sproc[3] == 0:
		sproc[3] = 1
	if sproc[3] == 1:
		sproc[3] = 2
		for i in range(250):
			var t = Timer.new()
			t.set_wait_time(0.4)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			PlayerVars.scooldown[3] += 1
			if PlayerVars.scooldown[3] >= 100:
				PlayerVars.scooldown[3] = 100
				break
		sproc[3] = 0
	if PlayerVars.Health <= 0 and PlayerVars.Health >= -998:
		PlayerVars.Health = -999
		dexec = true
		var t = Timer.new()
		t.set_wait_time(2.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")