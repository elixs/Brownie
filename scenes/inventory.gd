extends MarginContainer

onready var grid_container = $GridContainer

var Item = preload("res://scenes/item.tscn")

var grabbed_item: Node2D setget set_grabbed_item

func _ready():
	var file = File.new()
	file.open("res://data/items.json", File.READ)
	InventoryManager.data = JSON.parse(file.get_as_text()).result
	file.close()
	file.open("res://data/inventory.json", File.READ)
	InventoryManager.inventory = JSON.parse(file.get_as_text()).result
	file.close()
	
	for slot in grid_container.get_children():
		slot.connect("selected", self, "_on_slot_selected", [slot])
	
	for slotIndex in InventoryManager.inventory.keys():
		var item_dict = InventoryManager.inventory[slotIndex] # {id, quantity}
		var item_data = InventoryManager.data[item_dict.id]
		var item = Item.instance()
		item.id = item_dict.id
		item.icon = load("res://assets/sf_items/%s" % item_data.icon)
		item.quantity = item_dict.quantity
		var slot = grid_container.get_child(int(slotIndex))
		slot.item = item


func _process(delta: float) -> void:
	if grabbed_item:
		grabbed_item.global_position = get_global_mouse_position()

func _on_slot_selected(slot: Slot):
	if grabbed_item:
		if slot.item:
			var stack_size = InventoryManager.data[grabbed_item.id].stack_size
			if grabbed_item.id == slot.item.id:
				if slot.item.quantity + grabbed_item.quantity <= stack_size:
					var item = grabbed_item
					self.grabbed_item = null
					item.queue_free()
					slot.item.quantity += item.quantity
				else:
					var diff = slot.item.quantity + grabbed_item.quantity - stack_size
					grabbed_item.quantity = diff
					slot.item.quantity = stack_size
			else:
				var temp_item = slot.item
				slot.item = grabbed_item
				self.grabbed_item = temp_item
		else:
			slot.item = grabbed_item
			self.grabbed_item = null
	else:
		if slot.item:
			self.grabbed_item = slot.item
			slot.item = null
		else:
			pass # do nothing


func set_grabbed_item(value):
	grabbed_item = value
	if grabbed_item:
		if grabbed_item.get_parent():
			grabbed_item.get_parent().remove_child(grabbed_item)
		add_child(grabbed_item)
	
