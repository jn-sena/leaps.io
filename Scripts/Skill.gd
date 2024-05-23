extends Area2D

var slot = 0
var inm = false
var sid = 0

var fireball = preload("res://Assets/Skills/Fireball/Fireball.png")

func _ready():
	var nme = name
	nme.replace("Skill", "")
	slot = int(nme)


func _process(delta):
	if PlayerVars.skills[slot] == 0:
		get_node("Skill").texture = null
		sid = 0
	elif PlayerVars.skills[slot] == 1:
		get_node("Skill").set_texture(fireball)
		sid = 2001
	if not PlayerVars.skills[slot] == 0:
		get_node("Cooldown").value = PlayerVars.scooldown[slot]

func _on_Slot_body_entered(body):
	if body.name == "Cursor" and PlayerVars.inventory:
		get_node("Selected").visible = true
		inm = true

func _on_Slot_body_exited(body):
	if body.name == "Cursor":
		get_node("Selected").visible = false
		inm = false

func _input(ev):
	if ev.is_action_pressed("game_exec") and inm:
		if not sid == 0:
			var sindex = 0
			for i in range(49):
				if i > 3 and (PlayerVars.items[i][0] == 0 or PlayerVars.items[i][0] == sid):
					sindex = i
					break
			PlayerVars.items[sindex][1] += 1
			PlayerVars.items[sindex][0] = sid
			PlayerVars.skills[slot] = 0