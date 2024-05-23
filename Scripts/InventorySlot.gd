extends Area2D

var slot = 0

var inm = false

var ifeather = preload("res://Assets/Items/feather.png")
var ihelmet = preload("res://Assets/Items/helmet.png")
var ifrbl = preload("res://Assets/Skills/Fireball/Fireball.png")
var iswrd = preload("res://Assets/Items/sword.png")

func _on_Slot_body_entered(body):
	if body.name == "Cursor":
		get_node("TextureRect").visible = true
		inm = true
	PlayerVars.isid = PlayerVars.items[slot][0]

func _on_Slot_body_exited(body):
	if body.name == "Cursor":
		get_node("TextureRect").visible = false
		inm = false

func _ready():
	slot = int(self.name.replace("Slot", ""))

func _process(delta):
	if PlayerVars.inventory:
		var itemid = PlayerVars.items[slot][0]
		var quantity = PlayerVars.items[slot][1]
		if quantity <= 0 or slot <= 3:
			get_node("Quantity").visible = false
		else:
			get_node("Quantity").visible = true
			get_node("Quantity").text = str(quantity)
		if itemid == 0 or quantity <= 0:
			get_node("Item").texture = null
		if itemid == 1 and quantity > 0:
			get_node("Item").set_texture(ifeather)
		if itemid == 1001 and quantity > 0:
			get_node("Item").set_texture(ihelmet)
		if itemid == 2001 and quantity > 0:
			get_node("Item").set_texture(ifrbl)
		if itemid == 1002 and quantity > 0:
			get_node("Item").set_texture(iswrd)
	if PlayerVars.items[0][0] == 1001:
		PlayerVars.helmet = 1
	else:
		PlayerVars.helmet = 0
	if PlayerVars.items[2][0] == 1002:
		PlayerVars.sword = 1
	else:
		PlayerVars.sword = 0

func _input(ev):
	if ev.is_action_pressed("game_exec") and inm:
		if not slot <= 3:
			if PlayerVars.items[slot][0] == 1001 and PlayerVars.items[slot][1] >= 1:
				if not PlayerVars.items[0][0] == 1001:
					if PlayerVars.items[slot][1] == 1:
						PlayerVars.items[slot][0] = 0
						PlayerVars.items[slot][1] = 0
					elif PlayerVars.items[slot][1] > 1:
						PlayerVars.items[slot][1] -= 1
					if PlayerVars.items[0][0] == 0 or PlayerVars.items[0][1] <= 0:
						PlayerVars.items[0][0] = 1001
						PlayerVars.items[0][1] = 1
					else:
						var sindex = 0
						for i in range(49):
							if i > 3 and (PlayerVars.items[i][0] == 0 or PlayerVars.items[i][0] == PlayerVars.items[slot][0]):
								sindex = i
								break
							PlayerVars.items[sindex][1] += 1
							PlayerVars.items[sindex][0] = PlayerVars.items[0][0]
							PlayerVars.items[0][0] = 1001
							PlayerVars.items[0][1] = 1
			if PlayerVars.items[slot][0] == 2001 and PlayerVars.items[slot][1] >= 1:
				if not PlayerVars.skills[0] == 1:
					if PlayerVars.items[slot][1] == 1:
						PlayerVars.items[slot][0] = 0
						PlayerVars.items[slot][1] = 0
					else:
						PlayerVars.items[slot][1] -= 1
					PlayerVars.skills[0] = 1
					PlayerVars.scooldown[0] = 100
			if PlayerVars.items[slot][0] == 1002 and PlayerVars.items[slot][1] >= 1:
				if not PlayerVars.items[2][0] == 1002:
					if PlayerVars.items[slot][1] == 1:
						PlayerVars.items[slot][0] = 0
						PlayerVars.items[slot][1] = 0
					elif PlayerVars.items[slot][1] > 1:
						PlayerVars.items[slot][1] -= 1
					if PlayerVars.items[2][0] == 0 or PlayerVars.items[2][1] <= 0:
						PlayerVars.items[2][0] = 1002
						PlayerVars.items[2][1] = 1
					else:
						var sindex = 0
						for i in range(49):
							if i > 3 and (PlayerVars.items[i][0] == 0 or PlayerVars.items[i][0] == PlayerVars.items[slot][0]):
								sindex = i
								break
							PlayerVars.items[sindex][1] += 1
							PlayerVars.items[sindex][0] = PlayerVars.items[0][0]
							PlayerVars.items[2][0] = 1002
							PlayerVars.items[2][1] = 1
		else:
			if slot == 0:
				var sindex = 0
				for i in range(49):
					if i > 3 and (PlayerVars.items[i][0] == 0 or PlayerVars.items[i][0] == PlayerVars.items[slot][0]):
						sindex = i
						break
				PlayerVars.items[sindex][1] += 1
				PlayerVars.items[sindex][0] = PlayerVars.items[slot][0]
				PlayerVars.items[slot][0] = 0
				PlayerVars.items[slot][1] = 0
			if slot == 2:
				var sindex = 0
				for i in range(49):
					if i > 3 and (PlayerVars.items[i][0] == 0 or PlayerVars.items[i][0] == PlayerVars.items[slot][0]):
						sindex = i
						break
				PlayerVars.items[sindex][1] += 1
				PlayerVars.items[sindex][0] = PlayerVars.items[slot][0]
				PlayerVars.items[slot][0] = 0
				PlayerVars.items[slot][1] = 0