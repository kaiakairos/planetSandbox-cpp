extends Node2D

@onready var holdSlot = $holdingSlot

@onready var crafting = $Menu/Crafting

var invOpen = false

func _ready():
	#assign self to slots
	for slot in $Hotbar.get_children():
		slot.parent = self
	for slot in $Menu/InventoryBody.get_children():
		slot.parent = self
	for slot in $Menu/ArmorSlots.get_children():
		slot.parent = self
	for slot in $Menu/AccessorySlots.get_children():
		slot.parent = self
	
	$Menu.visible = false
	
	# connect health bar
	PlayerData.connect("updateHealth",updateHealth)
	
func _process(delta):
	holdSlot.position = to_local(get_global_mouse_position()) - Vector2(6,6)
	if Input.is_action_just_pressed("inventory"):
		invOpen = !invOpen
		$Menu.visible = invOpen
		
		if invOpen:
			crafting.createCraftingIcons()
	
	# hotbar scrolling
	var curSlot = PlayerData.selectedSlot
	if Input.is_action_just_pressed("scroll_up"):
		curSlot -= 1
		if curSlot < 0:
			curSlot = 9
		PlayerData.selectSlot(curSlot)
		for slot in $Hotbar.get_children():
			slot.updateSelected()
	elif Input.is_action_just_pressed("scroll_down"):
		curSlot += 1
		if curSlot > 9:
			curSlot = 0
		PlayerData.selectSlot(curSlot)
		for slot in $Hotbar.get_children():
			slot.updateSelected()
	
func clickedSlot(slot):
	if !invOpen:
		return
	if PlayerData.inventory[49][0] == -1:
		PlayerData.swapItem(slot,49)
		return
	elif PlayerData.inventory[slot][0] == -1:
		PlayerData.swapItem(slot,49)
		return
	elif PlayerData.inventory[slot][0] != PlayerData.inventory[49][0]:
		PlayerData.swapItem(slot,49)
		return
	else:
		var maxStack = ItemData.data[PlayerData.inventory[slot][0]].maxStackSize
		var total = PlayerData.inventory[slot][1] + PlayerData.inventory[49][1]
		if total <= maxStack:
			PlayerData.inventory[slot][1] = total
			PlayerData.inventory[49] = [-1,-1]
		else:
			PlayerData.inventory[slot][1] = maxStack
			PlayerData.inventory[49][1] = total - maxStack 
		PlayerData.emit_signal("updateInventory")

func splitSlot(slot):
	if !invOpen:
		return
	#If Hand slot is empty
	if PlayerData.inventory[49][0] == -1:
		var amount = PlayerData.inventory[slot][1]
		var half = PlayerData.inventory[slot][1] / 2
		if amount <= 1:
			return
		
		PlayerData.inventory[slot][1] = half
		PlayerData.inventory[49] = [PlayerData.inventory[slot][0],amount-half]
		PlayerData.emit_signal("updateInventory")
		return
	#If placement slot is empty
	elif PlayerData.inventory[slot][0] == -1:
		PlayerData.inventory[slot] = [PlayerData.inventory[49][0],1]
		PlayerData.inventory[49][1] -= 1
		if PlayerData.inventory[49][1] <= 0:
			PlayerData.inventory[49] = [-1,-1]
		PlayerData.emit_signal("updateInventory")
		return
	#If neither are empty but they aren't the same item type
	elif PlayerData.inventory[slot][0] != PlayerData.inventory[49][0]:
		return
	#If neither are empty but they ARE the same item type
	else:
		var maxStack = ItemData.data[PlayerData.inventory[slot][0]].maxStackSize
		
		if PlayerData.inventory[slot][1] >= maxStack:
			return
		
		PlayerData.inventory[slot][1] += 1
		
		PlayerData.inventory[49][1] -= 1
		if PlayerData.inventory[49][1] <= 0:
			PlayerData.inventory[49] = [-1,-1]
		PlayerData.emit_signal("updateInventory")
		return
		
func updateHealth():
	$HealthBar/healthText.text = str(PlayerData.currentHealth) + " / " + str(PlayerData.maxHealth)
	$HealthBar/bar.scale.x = PlayerData.currentHealth / 2.0
	$HealthBar/barShadow.scale.x = PlayerData.maxHealth / 2.0
