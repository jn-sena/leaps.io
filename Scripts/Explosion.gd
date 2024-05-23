extends CPUParticles2D

var _timer = null


func _ready():
	get_node("KinematicBody2D/CollisionShape2D").shape.radius = 10
	_timer = Timer.new()
	self.add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(0.1)
	_timer.set_one_shot(false)
	_timer.start()


func _on_Timer_timeout():
	get_node("KinematicBody2D/CollisionShape2D").shape.radius += 0.25