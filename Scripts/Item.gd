extends Area2D

var ifeather = preload("res://Assets/Items/feather.png")
var icoin = preload("res://Assets/Items/ByteCoin.png")
var ihelmet = preload("res://Assets/Items/helmet.png")
var ifrbl = preload("res://Assets/Skills/Fireball/Fireball.png")
var iswrd = preload("res://Assets/Items/sword.png")

var velocity = Vector2()
var stamp = false
export(int) var id

func _ready():
	stamp = true
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	stamp = false
	t.queue_free()

func _process(delta):
	if id == 1:
		get_node("Sprite").set_texture(ifeather)
	elif id == -1:
		get_node("Sprite").set_texture(icoin)
	elif id == 2001:
		get_node("Sprite").set_texture(ifrbl)
	elif id == 1001:
		get_node("Sprite").set_texture(ihelmet)
	elif id == 1002:
		get_node("Sprite").set_texture(iswrd)

func _physics_process(delta):
	if not stamp:
		look_at(PlayerVars.pos)
		velocity = Vector2(750, 0).rotated(rotation)
		position += velocity * delta

func _on_Item_body_entered(body):
	if body.name == "Player":
		if id > 0:
			var sindex = 0
			for i in range(49):
				if i > 3 and (PlayerVars.items[i][0] == 0 or PlayerVars.items[i][0] == id):
					sindex = i
					break
			PlayerVars.items[sindex][1] += 1
			PlayerVars.items[sindex][0] = id
			get_parent().get_node("CanvasLayer/HUD/LastIt").texture = get_node("Sprite").texture
			get_parent().get_node("CanvasLayer/HUD/LastIt").modulate.a = 1
			get_parent().remove_child(self)
		if id == -1:
			PlayerVars.balance += 5
			get_parent().remove_child(self)