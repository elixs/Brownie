extends MarginContainer

onready var grid_container = $GridContainer

func _ready():
	var file = File.new()
	file.open("res://data/items.json", File.READ)
	var items = JSON.parse(file.get_as_text()).result
	file.close()
	file.open("res://data/inventory.json", File.READ)
	var inventory = JSON.parse(file.get_as_text()).result
	file.close()
	
	for slotIndex in inventory.keys():
		var slot: Slot = grid_container.get_child(int(slotIndex))
		var item = items[inventory[slotIndex].item]
		var quantity = inventory[slotIndex].quantity
		slot.set_item(item, quantity)
