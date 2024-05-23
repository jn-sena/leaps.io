extends KinematicBody2D

export (Vector2) var target
export (float) var level = 1
export (float) var health = 100
export (float) var speed = 750
export (float) var stamina = 100

const GRAVITY = 250
const DEACCEL = 0.25

var stcool = false
var _timer = null
var velocity = Vector2()
var proc = false

func _ready():
	_timer = Timer.new()
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.5)
	_timer.set_one_shot(false)
	_timer.start()

func staminaRegen(kat):
	stcool = true
	var tt = Timer.new()
	tt.set_wait_time(4)
	tt.set_one_shot(true)
	self.add_child(tt)
	tt.start()
	yield(tt, "timeout")
	stcool = false
	if stcool:
		return
	for i in range(100):
		if stcool:
			return
		if stamina >= 100:
			return
		var t = Timer.new()
		t.set_wait_time(0.2)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		stamina += kat


func _on_Timer_timeout():
	get_node("TargetArrow").look_at(target)
	var stscn = load("res://Scenes/Smoke.tscn")
	var smoke = stscn.instance()
	get_parent().add_child(smoke)
	smoke.global_position = global_position
	smoke.set_name("Particle")
	smoke.emitting = true
	staminaRegen(1)
	velocity = Vector2(speed, 25).rotated(get_node("TargetArrow").rotation)

func _process(delta):
	if health <= 0:
		get_parent().remove_child(self)
	var balls = get_tree().get_nodes_in_group("balls")
	var nearest_ball = balls[0]
	for ball in balls:
		if ball.global_position.distance_to(global_position) < nearest_ball.global_position.distance_to(global_position):
			nearest_ball = ball
	if nearest_ball.global_position.distance_to(global_position) * 1.5 < PlayerVars.gpos.distance_to(global_position):
		target = nearest_ball.global_position
	else:
		target = PlayerVars.gpos

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if velocity.x < 0:
		velocity.x += DEACCEL
	elif velocity.x > 0:
		velocity.x -= DEACCEL
	var collision
	if health > 0:
		collision = move_and_collide(velocity * delta)
	if collision:
		if not collision.collider.name.begins_with("Cursor") and not collision.collider.name.begins_with("Spell"):
			velocity = velocity.bounce(collision.normal)
		if collision.collider.name.begins_with("Player") or collision.collider.name.begins_with("Spell"):
			var escn = load("res://Scenes/Explosion.tscn")
			var etam = escn.instance()
			get_parent().add_child(etam)
			etam.global_position = collision.collider.global_position
			etam.set_name("Particle")
			etam.emitting = true
			health -= 25
		if collision.collider.name.begins_with("Player"):
			if not proc:
				proc = true
				get_node("Collision").disabled = true
				visible = false
				var etscn = load("res://Scenes/Explosion.tscn")
				var etam = etscn.instance()
				get_parent().add_child(etam)
				etam.scale = Vector2(0.5, 0.5)
				etam.global_position = global_position
				etam.set_name("Particle")
				etam.emitting = true
				for i in range(5):
					var t = Timer.new()
					t.set_wait_time(0.1)
					t.set_one_shot(true)
					self.add_child(t)
					t.start()
					yield(t, "timeout")
					PlayerVars.Health -= 1
				proc = false
				get_parent().remove_child(self)
		if collision.collider.name.begins_with("BoostBall") or collision.collider.name.begins_with("@BoostBall") or collision.collider.name.begins_with("StaminaBall") or collision.collider.name.begins_with("@StaminaBall") or collision.collider.name.begins_with("DamageBall") or collision.collider.name.begins_with("PhaseBall") or collision.collider.name.begins_with("BossOctagon"):
			if collision.collider.name.begins_with("StaminaBall") or collision.collider.name.begins_with("@StaminaBall"):
				stamina += 25
				collision.collider.get_parent().remove_child(collision.collider)
				var stscn = load("res://Scenes/Stamina.tscn")
				var stam = stscn.instance()
				get_parent().add_child(stam)
				stam.global_position = collision.collider.global_position
				stam.set_name("Particle")
				stam.emitting = true
			elif collision.collider.name.begins_with("BoostBall") or collision.collider.name.begins_with("@BoostBall"):
				stamina += 5
				collision.collider.get_parent().remove_child(collision.collider)