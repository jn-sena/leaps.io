extends KinematicBody2D

var posit = Vector2()

func _ready():
	posit = position

func hit():
	var delta = 0
	var velocity = Vector2(0, 0)
	if get_parent().name.begins_with("Boss"):
		for i in range(25):
			var collision = move_and_collide(velocity * delta)
			if collision:
				if collision.collider.name.begins_with("BT"):
					collision.collider.get_parent().remove_child(collision.collider)
	if get_parent().name.begins_with("H"):
		get_parent().get_parent().remove_child(get_parent())
	get_parent().remove_child(self)

func _process(delta):
	var collision = move_and_collide(Vector2(0, 0))
	position = posit
	if not collision:
		get_parent().remove_child(self)