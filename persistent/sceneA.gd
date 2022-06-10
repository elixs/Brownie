extends Node2D


onready var label = $Label

export(Script) var Stats

func _ready():
	_update_text()


func _input(event):
	if event.is_action_pressed("ui_accept") and not event.is_echo():
		Persistent.text = "owo"
		_update_text()
	if event.is_action_pressed("ui_right") and not event.is_echo():
		get_tree().change_scene("res://persistent/sceneB.tscn")
	if event.is_action_pressed("save") and not event.is_echo():
#		save_game_json()
#		save_game_persistent()
#		save_game_persistent2()
		save_game_resource()
#		save_game_config()
	if event.is_action_pressed("load") and not event.is_echo():
#		load_game_json()
#		load_game_persistent()
#		load_game_persistent2()
		load_game_resource()
#		load_game_config()


func _update_text():
	label.text = Persistent.text


func save_game_json():
	var data = {
		"hp": 100,
		"luck": 42,
		"name": "jalkdfh"
	}
	var file = File.new()
	file.open("user://game.json", File.WRITE)
	file.store_string(JSON.print(data, "\t"))
	file.close()

func load_game_json():
	var file = File.new()
	if not file.file_exists("user://game.json"):
		return
	file.open("user://game.json", File.READ)
	var data = JSON.parse(file.get_as_text()).result
	file.close()
	print(data.hp)
	print(data.luck)
	print(data.name)
	
func save_game_persistent():
	var file = File.new()
	file.open("user://game.save", File.WRITE)
#	file.open_encrypted_with_pass("user://game.save", File.WRITE, "1234")
	for node in get_tree().get_nodes_in_group("Persistent"):
		if node.has_method("save"):
			var data = node.save()
			file.store_line(to_json(data))
	file.close()


func load_game_persistent():
	var file = File.new()
	if not file.file_exists("user://game.save"):
		return
	file.open("user://game.save", File.READ)
#	file.open_encrypted_with_pass("user://game.save", File.READ, "1234")
	
	for node in get_tree().get_nodes_in_group("Persistent"):
		node.queue_free()
		
	while file.get_position() < file.get_len():
		var data = parse_json(file.get_line())
		var node = load(data.filename).instance()
		node.add_to_group("Persistent")
		get_tree().get_root().get_node(data.parent).add_child(node)
		node.position = str2var(data.position)
		node.modulate = str2var(data.modulate)
		for key in data.keys():
			if key in ["filename", "parent", "position", "modulate"]:
				continue
			node.set(key, data[key])
	
	file.close()


func save_game_persistent2():
	var file = File.new()
	file.open("user://game2.save", File.WRITE)
	file.store_32(24)
	file.store_32(198371232)
	file.store_float(2312.234134)
	file.close()


func load_game_persistent2():
	var file = File.new()
	file.open("user://game2.save", File.READ)
	print(file.get_32())
	print(file.get_32())
	print(file.get_float())
	file.close()


func save_game_resource():
	var stats = Stats.new()
	stats.hp = 355
	stats.defense = 2
	stats.luck = 42.42
	stats.name = "28jkvnlad"
	ResourceSaver.save("user://stats.tres", stats)
#	var file = File.new()
#	file.open("user://stats.tres", File.WRITE)
#	file.store_var(inst2dict(stats))
#	file.close()
	


func load_game_resource():
	var stats = load("user://stats.tres")
#	var file = File.new()
#	file.open("user://stats.tres", File.READ)
#	var stats = dict2inst(file.get_var())
#	file.close()
	print(stats.hp)
	print(stats.defense)
	print(stats.luck)
	print(stats.name)

func save_game_config():
	var config = ConfigFile.new()
	config.set_value("style", "font", 42)
	config.set_value("style", "color", var2str(Color.rebeccapurple))
	config.set_value("meh", "owo", "123")
	config.set_value("meh", "awa", 3573.2342)
	config.save("user://game.cfg")

func load_game_config():
	var config = ConfigFile.new()
	config.load("user://game.cfg")
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			prints(section, key, config.get_value(section, key))
