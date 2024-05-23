extends Area2D

var ifeather = preload("res://Assets/Items/feather.png")
var ihelmet = preload("res://Assets/Items/helmet.png")
var ifrbl = preload("res://Assets/Skills/Fireball/Fireball.png")

func _process(delta):
	if PlayerVars.isid == 0:
		get_node("Item").texture = null
		get_node("Name").text = ""
		get_node("Description").text = ""
	elif PlayerVars.isid == 1:
		get_node("Item").set_texture(ifeather)
		get_node("Name").text = "Feather"
		get_node("Description").text = "A crafting material."
	elif PlayerVars.isid == 1001:
		get_node("Item").set_texture(ihelmet)
		get_node("Name").text = "Helmet"
		get_node("Description").text = "Increases defense. (+25 HP)"
	elif PlayerVars.isid == 2001:
		get_node("Item").set_texture(ifrbl)
		get_node("Name").text = "Fireball Spell"
		get_node("Description").text = "Throws a fireball. (1.5s Cooldown)"