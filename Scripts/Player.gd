extends KinematicBody2D

const GRAVITY = 250
const DEACCEL = 0.25

var _timer = null
var time = null
var t = null

var shake = 0
var shake_magnitude = 15
var etime = 0
var rng = RandomNumberGenerator.new()

var zproc = false

export (int) var speed = 750
var velocity = Vector2()

var ihelmet = preload("res://Assets/Items/helmet.png")
var mcursor = preload("res://Assets/cursor.png")
var gcross = preload("res://Assets/Crosshair.png")

func _fireball():
	var mpos = get_global_mouse_position()
	var scn = preload("res://Assets/Skills/Fireball/SpellFireball.tscn")
	var frbl = scn.instance()
	frbl.name = "SpellFireball"
	frbl.global_position = global_position
	frbl.target = mpos
	get_parent().add_child(frbl)

func _ready():
	Input.set_custom_mouse_cursor(gcross)
	position = PlayerVars.pos
	t = Timer.new()
	self.add_child(t)
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(2.5)
	_timer.set_one_shot(false)
	_timer.start()
	time = Timer.new()
	add_child(time)
	time.connect("timeout", self, "_on_Save_timeout")
	time.set_wait_time(30.0)
	time.set_one_shot(false)
	time.start()

func _nball():
	var nrng = RandomNumberGenerator.new()
	if not PlayerVars.otut:
		var ppos = global_position
		var xpos = Vector2()
		nrng.randomize()
		var r = nrng.randi_range(1, 2)
		if r == 1:
			var scn = load("res://Scenes/BoostBall.tscn")
			var bl = scn.instance()
			bl.set_name("BoostBall")
			get_parent().add_child(bl)
			bl.add_to_group("balls")
			nrng.randomize()
			bl.global_position = Vector2((nrng.randi_range((ppos.x-512), (ppos.x+512))), (nrng.randi_range((ppos.y-512), (ppos.y+512))))
			xpos = bl.global_position
			bl.posit = xpos
		elif r == 2:
			var scn = load("res://Scenes/StaminaBall.tscn")
			var bl = scn.instance()
			bl.set_name("StaminaBall")
			get_parent().add_child(bl)
			bl.add_to_group("balls")
			nrng.randomize()
			bl.global_position = Vector2((nrng.randi_range((ppos.x-512), (ppos.x+512))), (nrng.randi_range((ppos.y-512), (ppos.y+512))))
			xpos = bl.global_position
			bl.posit = xpos
		var etscn = load("res://Scenes/Pop.tscn")
		var etam = etscn.instance()
		get_parent().add_child(etam)
		etam.global_position = xpos
		etam.set_name("Particle")
		etam.emitting = true

func _process(delta):
	if not PlayerVars.qopos == Vector2(0, 0):
		get_node("QuestNav").visible = true
		get_node("QuestNav").look_at(PlayerVars.qopos)
	else:
		get_node("QuestNav").visible = false
	if PlayerVars.dexec:
		PlayerVars.dexec = false
		shake = shake_magnitude * 5
		for i in range(5):
			var etscn = load("res://Scenes/Explosion.tscn")
			var etam = etscn.instance()
			get_parent().add_child(etam)
			etam.global_position = global_position
			etam.set_name("Particle")
			etam.emitting = true
		visible = false
		PlayerVars.Stamina = 0
		var t = Timer.new()
		t.set_wait_time(2.5)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		PlayerVars.saveGame()
		PlayerVars.Health = 100
		PlayerVars.Stamina = 100
		get_tree().change_scene("res://Scenes/Menu.tscn")
	if PlayerVars.helmet == 0:
		get_node("Helmet").visible = false
		get_node("HelmetCollision").disabled = true
		get_node("Helmet").texture = null
	elif PlayerVars.helmet == 1:
		get_node("Helmet").visible = true
		get_node("HelmetCollision").disabled = false
		get_node("Helmet").set_texture(ihelmet)
	PlayerVars.pos = position
	PlayerVars.gpos = global_position
	if PlayerVars.bossDead:
		for i in range(255):
			get_parent().get_node("CanvasLayer/Fade/Black").modulate.a += 0.001
			var tt = Timer.new()
			tt.set_wait_time(0.1)
			tt.set_one_shot(true)
			add_child(tt)
			tt.start()
			yield(tt, "timeout")
			if get_parent().get_node("CanvasLayer/Fade/Black").modulate.a >= 1:
				break
		PlayerVars.bossDead = false
		PlayerVars.otut = false
		get_tree().change_scene("res://Scenes/TheMinusWorld.tscn")
	if shake > 0:
		get_node("CamBox/Camera2D").offset = Vector2(rand_range(-shake, shake), rand_range(-shake, shake));
		shake *= 0.9
	if PlayerVars.paused:
		Input.set_custom_mouse_cursor(mcursor)
		Engine.time_scale = 0.05
		get_parent().get_node("CanvasLayer/PauseMenu").visible = true
		get_parent().get_node("CanvasLayer/Inventory").rect_position.x = -512
		PlayerVars.inventory = false
	elif PlayerVars.inventory:
		Input.set_custom_mouse_cursor(mcursor)
		PlayerVars.ianim = true
		Engine.time_scale = 0.05
		for i in range(8):
			if get_parent().get_node("CanvasLayer/Inventory").rect_position.x >= 0:
				get_parent().get_node("CanvasLayer/Inventory").rect_position.x = -54
			get_parent().get_node("CanvasLayer/Inventory").rect_position.x += 64
			t.set_wait_time(0.1)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
	elif PlayerVars.crafting:
		Input.set_custom_mouse_cursor(mcursor)
		Engine.time_scale = 0.0001
		get_parent().get_node("CanvasLayer/PauseMenu").visible = false
		get_parent().get_node("CanvasLayer/Inventory").rect_position.x = -512
		get_parent().get_node("CanvasLayer/CraftingMenu").visible = true
	else:
		Input.set_custom_mouse_cursor(gcross)
		var ianiming
		if PlayerVars.ianim:
			PlayerVars.ianim = false
			ianiming = true
			Engine.time_scale = 0.05
			for i in range(8):
				if get_parent().get_node("CanvasLayer/Inventory").rect_position.x < -512:
					get_parent().get_node("CanvasLayer/Inventory").rect_position.x = -512
				get_parent().get_node("CanvasLayer/Inventory").rect_position.x -= 64
				t.set_wait_time(0.1)
				t.set_one_shot(true)
				t.start()
				yield(t, "timeout")
			PlayerVars.ianim = false
			ianiming = false
		if not ianiming:
			Engine.time_scale = 1
		get_parent().get_node("CanvasLayer/CraftingMenu").visible = false
		get_parent().get_node("CanvasLayer/PauseMenu").visible = false
		get_parent().get_node("CanvasLayer/Inventory").rect_position.x = -512
	if Input.is_action_just_released("game_skill0") and PlayerVars.Health > 0:
		if PlayerVars.skills[0] == 1:
			if PlayerVars.scooldown[0] >= 100:
				_fireball()
				PlayerVars.scooldown[0] = 0
	if Input.is_action_just_released("game_skill1") and PlayerVars.Health > 0:
		if PlayerVars.skills[1] == 1:
			if PlayerVars.scooldown[1] >= 100:
				_fireball()
				PlayerVars.scooldown[1] = 0
	if Input.is_action_just_released("game_skill2") and PlayerVars.Health > 0:
		if PlayerVars.skills[2] == 1:
			if PlayerVars.scooldown[2] >= 100:
				_fireball()
				PlayerVars.scooldown[2] = 0
	if Input.is_action_just_released("game_skill3") and PlayerVars.Health > 0:
		if PlayerVars.skills[3] == 1:
			if PlayerVars.scooldown[3] >= 100:
				_fireball()
				PlayerVars.scooldown[3] = 0
	if (Input.is_action_pressed("game_exec")) and PlayerVars.Stamina >= 10 and not PlayerVars.paused:
		get_node("TargetArrow").look_at(get_global_mouse_position())
		get_node("TargetArrow").visible = true
		Engine.time_scale = 0.25
	elif not PlayerVars.paused and not PlayerVars.inventory and not Input.is_action_pressed("game_exec") and not PlayerVars.dialog and not PlayerVars.odialog and not PlayerVars.crafting:
		get_node("TargetArrow").visible = false
		Engine.time_scale = 1
	if PlayerVars.dialog or PlayerVars.odialog:
		Engine.time_scale = 0.0075
	if Input.is_action_just_released("game_exec") and PlayerVars.Health > 0 and PlayerVars.Stamina >= 10 and not PlayerVars.paused:
		var stscn = load("res://Scenes/Smoke.tscn")
		var smoke = stscn.instance()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		smoke.set_name("Particle")
		smoke.emitting = true
		if PlayerVars.level >= 3:
			shake = shake_magnitude
			var etscn = load("res://Scenes/Explosion.tscn")
			var etam = etscn.instance()
			get_parent().add_child(etam)
			etam.global_position = global_position
			etam.set_name("Particle")
			etam.emitting = true
		velocity = Vector2(speed, 25).rotated(get_node("TargetArrow").rotation)
		for i in range(10):
			PlayerVars.Stamina -= 1
			t.set_wait_time(0.01)
			t.set_one_shot(true)
			t.start()
			yield(t, "timeout")
		PlayerVars.stcool = true
		PlayerVars.staminaRegen(1)
	if Input.is_action_just_pressed("game_weapon") and PlayerVars.Health > 0 and not PlayerVars.paused:
		get_node("SwordContainer/Sword").hit()
	if PlayerVars.otut:
		if get_parent().get_node("CanvasLayer/Tutorial").visible == true:
			Engine.time_scale = 0.01
		if Input.is_action_just_pressed("game_exec"):
			etime += 1
			if etime >= 2:
				get_parent().get_node("CanvasLayer/Tutorial").visible = false
				Engine.time_scale = 1

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if velocity.x < 0:
		velocity.x += DEACCEL
	elif velocity.x > 0:
		velocity.x -= DEACCEL
	var collision
	if PlayerVars.Health > 0:
		collision = move_and_collide(velocity * delta)
	if collision:
		if not collision.collider.name.begins_with("Cursor") and not collision.collider.name.begins_with("Spell"):
			velocity = velocity.bounce(collision.normal)
		if (collision.collider.name.begins_with("QuestNPC") or collision.collider.name.begins_with("CraftNPC")) and not PlayerVars.dialog and not PlayerVars.odialog and not PlayerVars.inventory and not PlayerVars.crafting and not PlayerVars.paused:
			var cldr = collision.collider
			cldr.talk()
		if collision.collider.name.begins_with("HNPC"):
			var etscn = load("res://Scenes/Explosion.tscn")
			var etam = etscn.instance()
			get_parent().add_child(etam)
			etam.global_position = collision.collider.global_position
			etam.set_name("Particle")
			etam.emitting = true
			shake = shake_magnitude / 2
			var cldr = collision.collider
			cldr.health -= 25
		if collision.collider.name.begins_with("BoostBall") or collision.collider.name.begins_with("@BoostBall") or collision.collider.name.begins_with("StaminaBall") or collision.collider.name.begins_with("@StaminaBall") or collision.collider.name.begins_with("DamageBall") or collision.collider.name.begins_with("PhaseBall") or collision.collider.name.begins_with("BossOctagon"):
			_nball()
			if collision.collider.name.begins_with("StaminaBall") or collision.collider.name.begins_with("@StaminaBall"):
				rng.randomize()
				var r = rng.randi_range(1, 8)
				if r == 5:
					var iscn = load("res://Scenes/Item.tscn")
					var itm = iscn.instance()
					get_parent().add_child(itm)
					itm.global_position = Vector2((rng.randi_range((collision.collider.global_position.x-50), (collision.collider.global_position.x+50))), (rng.randi_range((collision.collider.global_position.y-50), (collision.collider.global_position.y+50))))
					itm.set_name("Item")
					#rng.randomize()
					var ir = 0 # rng.randi_range(1, xd)
					if ir == 0:
						itm.id = 1
						var feather = preload("res://Assets/Items/feather.png")
						itm.get_node("Sprite").set_texture(feather)
				rng.randomize()
				var rr = rng.randi_range(1, 2)
				if rr == 2:
					var iscn = load("res://Scenes/Item.tscn")
					var itm = iscn.instance()
					get_parent().add_child(itm)
					itm.global_position = Vector2((rng.randi_range((collision.collider.global_position.x-50), (collision.collider.global_position.x+50))), (rng.randi_range((collision.collider.global_position.y-50), (collision.collider.global_position.y+50))))
					itm.set_name("Coin")
					itm.id = -1
					var coin = preload("res://Assets/Items/ByteCoin.png")
					itm.get_node("Sprite").set_texture(coin)
				rng.randomize()
				var rrr = rng.randi_range(1, 25)
				if rrr == 12:
					var iscn = load("res://Scenes/Item.tscn")
					var itm = iscn.instance()
					get_parent().add_child(itm)
					itm.global_position = Vector2((rng.randi_range((collision.collider.global_position.x-50), (collision.collider.global_position.x+50))), (rng.randi_range((collision.collider.global_position.y-50), (collision.collider.global_position.y+50))))
					itm.set_name("RareItem")
					rng.randomize()
					var ir = rng.randi_range(1, 2)
					if ir == 1:
						itm.id = 1001
						var helmet = preload("res://Assets/Items/helmet.png")
						itm.get_node("Sprite").set_texture(helmet)
					if ir == 2:
						itm.id = 2001
						var frbl = preload("res://Assets/Skills/Fireball/Fireball.png")
						itm.get_node("Sprite").set_texture(frbl)
				collision.collider.get_parent().remove_child(collision.collider)
				var stscn = load("res://Scenes/Stamina.tscn")
				var stam = stscn.instance()
				get_parent().add_child(stam)
				stam.global_position = collision.collider.global_position
				stam.set_name("Particle")
				stam.emitting = true
				if PlayerVars.level >= 2:
					shake = shake_magnitude
					var etscn = load("res://Scenes/Explosion.tscn")
					var etam = etscn.instance()
					get_parent().add_child(etam)
					etam.global_position = collision.collider.global_position
					etam.set_name("Particle")
					etam.emitting = true
				for i in range(10):
					PlayerVars.Stamina += 5
					t.set_wait_time(0.01)
					t.set_one_shot(true)
					t.start()
					yield(t, "timeout")
				for i in range(10):
					PlayerVars.xp += 2.5
					t.set_wait_time(0.01)
					t.set_one_shot(true)
					t.start()
					yield(t, "timeout")
			elif collision.collider.name.begins_with("DamageBall"):
				var etscn = load("res://Scenes/Explosion.tscn")
				var etam = etscn.instance()
				get_parent().add_child(etam)
				etam.global_position = collision.collider.global_position
				etam.set_name("Particle")
				etam.emitting = true
				shake = shake_magnitude
				collision.collider.hit()
			elif collision.collider.name.begins_with("PhaseBall"):
				for i in range(3):
					var etscn = load("res://Scenes/Explosion.tscn")
					var etam = etscn.instance()
					get_parent().add_child(etam)
					etam.global_position = collision.collider.global_position
					etam.set_name("Particle")
					etam.emitting = true
				shake = shake_magnitude * 10
				collision.collider.hit()
			elif collision.collider.name.begins_with("BossOctagon"):
				for i in range(100):
					if PlayerVars.Stamina >= 100:
						break
					PlayerVars.Stamina += 1
					t.set_wait_time(0.01)
					t.set_one_shot(true)
					t.start()
					yield(t, "timeout")
			elif collision.collider.name.begins_with("BoostBall") or collision.collider.name.begins_with("@BoostBall"):
				rng.randomize()
				var r = rng.randi_range(1, 8)
				if r == 5:
					var iscn = load("res://Scenes/Item.tscn")
					var itm = iscn.instance()
					get_parent().add_child(itm)
					itm.global_position = Vector2((rng.randi_range((collision.collider.global_position.x-50), (collision.collider.global_position.x+50))), (rng.randi_range((collision.collider.global_position.y-50), (collision.collider.global_position.y+50))))
					itm.set_name("Item")
					var ir = 0 # rng.randi_range(1, xd)
					if ir == 0:
						itm.id = 1
						var feather = preload("res://Assets/Items/feather.png")
						itm.get_node("Sprite").set_texture(feather)
				rng.randomize()
				var rr = rng.randi_range(1, 2)
				if rr == 2:
					var iscn = load("res://Scenes/Item.tscn")
					var itm = iscn.instance()
					get_parent().add_child(itm)
					itm.global_position = Vector2((rng.randi_range((collision.collider.global_position.x-50), (collision.collider.global_position.x+50))), (rng.randi_range((collision.collider.global_position.y-50), (collision.collider.global_position.y+50))))
					itm.set_name("Coin")
					itm.id = -1
					var coin = preload("res://Assets/Items/ByteCoin.png")
					itm.get_node("Sprite").set_texture(coin)
				rng.randomize()
				var rrr = rng.randi_range(1, 50)
				if rrr == 31:
					var iscn = load("res://Scenes/Item.tscn")
					var itm = iscn.instance()
					get_parent().add_child(itm)
					itm.global_position = Vector2((rng.randi_range((collision.collider.global_position.x-50), (collision.collider.global_position.x+50))), (rng.randi_range((collision.collider.global_position.y-50), (collision.collider.global_position.y+50))))
					itm.set_name("RareItem")
					rng.randomize()
					var ir = rng.randi_range(1, 3)
					if ir == 1:
						itm.id = 1001
						var helmet = preload("res://Assets/Items/helmet.png")
						itm.get_node("Sprite").set_texture(helmet)
					if ir == 2:
						itm.id = 2001
						var frbl = preload("res://Assets/Skills/Fireball/Fireball.png")
						itm.get_node("Sprite").set_texture(frbl)
					if ir == 3:
						itm.id = 1002
						var swrd = preload("res://Assets/Items/sword.png")
						itm.get_node("Sprite").set_texture(swrd)
				collision.collider.get_parent().remove_child(collision.collider)
				if PlayerVars.level >= 2:
					shake = shake_magnitude
					var etscn = load("res://Scenes/Explosion.tscn")
					var etam = etscn.instance()
					get_parent().add_child(etam)
					etam.global_position = collision.collider.global_position
					etam.set_name("Particle")
					etam.emitting = true
				for i in range(10):
					PlayerVars.Stamina += 0.5
					t.set_wait_time(0.01)
					t.set_one_shot(true)
					t.start()
					yield(t, "timeout")
				for i in range(10):
					PlayerVars.xp += 0.5
					t.set_wait_time(0.01)
					t.set_one_shot(true)
					t.start()
					yield(t, "timeout")
	get_node("Collision").look_at(velocity)
	get_node("Sprite").look_at(velocity)
	get_node("Helmet").look_at(velocity)
	get_node("HelmetCollision").look_at(velocity)
	get_node("SwordContainer").look_at(velocity)
	
func _input(ev):
	if ev.is_action_pressed("ui_pause") and PlayerVars.Health > 0:
		if not PlayerVars.dialog and not PlayerVars.odialog and not PlayerVars.inventory and not PlayerVars.crafting:
			PlayerVars.paused = !PlayerVars.paused
			if PlayerVars.paused:
				get_parent().get_node("CanvasLayer/HUD/Save").value = 0
				get_parent().get_node("CanvasLayer/HUD/Save").proc = false
				get_parent().get_node("CanvasLayer/HUD/Save").rev = false
				get_parent().get_node("CanvasLayer/HUD/Save").visible = true
				PlayerVars.saveGame()
		PlayerVars.inventory = false
		PlayerVars.crafting = false
	if ev.is_action_pressed("ui_inventory") and not PlayerVars.paused and not PlayerVars.dialog and not PlayerVars.odialog and not PlayerVars.crafting and PlayerVars.Health > 0:
		PlayerVars.inventory = !PlayerVars.inventory

func _on_Timer_timeout():
	_nball()

func _on_Save_timeout():
	if not PlayerVars.saving:
		get_parent().get_node("CanvasLayer/HUD/Save").visible = true
		PlayerVars.saveGame()