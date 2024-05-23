extends KinematicBody2D

export (float) var speed = 250
export (Vector2) var target

var velocity = Vector2()

var _timer = null

func _ready():
	for i in range(5):
		look_at(target)
	_timer = Timer.new()
	_timer.set_wait_time(0.25)
	_timer.set_one_shot(true)
	self.add_child(_timer)
	_timer.start()
	yield(_timer, "timeout")
	get_node("SpellCollision").disabled = false
	_timer.set_wait_time(4.75)
	_timer.set_one_shot(true)
	_timer.start()
	yield(_timer, "timeout")
	get_parent().remove_child(self)

func _physics_process(delta):
	velocity = Vector2(speed, 0).rotated(rotation)
	var collision = move_and_collide(velocity * delta)
	if collision:
		if not collision.collider.name.begins_with("Player") and not collision.collider.name.begins_with("Sword") and not collision.collider.name.begins_with("SwordContainer"):
			var etscn = load("res://Scenes/Explosion.tscn")
			var etam = etscn.instance()
			get_parent().add_child(etam)
			etam.global_position = collision.collider.global_position
			etam.set_name("Particle")
			etam.emitting = true
			collision.collider.get_parent().remove_child(collision.collider)
			get_parent().remove_child(self)