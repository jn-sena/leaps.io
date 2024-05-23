extends KinematicBody2D

var _timer = null

export (float) var health = 100

var dist = Vector2()

func _ready():
	_timer = Timer.new()
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(2.5)
	_timer.set_one_shot(false)
	_timer.start()

func _process(delta):
	if health <= 0:
		get_parent().remove_child(self)
	dist = global_position.distance_to(PlayerVars.gpos)

func _physics_process(delta):
	look_at(PlayerVars.gpos)

func _on_Timer_timeout():
	if dist <= 725 and PlayerVars.Health > 0:
		var scn = load("res://Assets/NPC/Shooter/Bullet.tscn")
		var bullet = scn.instance()
		get_parent().add_child(bullet)
		bullet.global_position = get_node("ShootPoint").global_position
		bullet.set_name("Bullet")