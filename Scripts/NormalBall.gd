extends KinematicBody2D

export (Vector2) var posit

func _ready():
	posit = position

func _physics_process(delta):
	var collision = move_and_collide(Vector2(0, 0))
	position = posit
	if collision:
		if collision.collider.name.begins_with("Sword") or collision.collider.name.begins_with("SwordContainer"):
			var etscn = load("res://Scenes/Explosion.tscn")
			var etam = etscn.instance()
			get_parent().add_child(etam)
			etam.global_position = collision.collider.global_position
			etam.set_name("Particle")
			etam.emitting = true
			get_parent().remove_child(self)