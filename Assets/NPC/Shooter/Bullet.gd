extends KinematicBody2D

export (float) var speed = 5

var velocity = Vector2(0, 0)

var proc = false

var _timer = null

func _ready():
	var etscn = load("res://Scenes/Explosion.tscn")
	var etam = etscn.instance()
	get_parent().add_child(etam)
	etam.scale = Vector2(0.5, 0.5)
	etam.global_position = global_position
	etam.set_name("Particle")
	etam.emitting = true
	_timer = Timer.new()
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(2.5)
	_timer.set_one_shot(false)
	_timer.start()

func _physics_process(delta):
	look_at(PlayerVars.gpos)
	velocity = Vector2(speed, 0).rotated(rotation)
	var collision = move_and_collide(velocity)
	if collision:
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

func _on_Timer_timeout():
	var etscn = load("res://Scenes/Explosion.tscn")
	var etam = etscn.instance()
	get_parent().add_child(etam)
	etam.scale = Vector2(0.5, 0.5)
	etam.global_position = global_position
	etam.set_name("Particle")
	etam.emitting = true
	get_parent().remove_child(self)