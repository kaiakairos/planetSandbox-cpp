extends NinePatchRect

@onready var sprite = $sprite
@onready var amountLabel = $amount

var recipe :CraftingRecipe

var craftableTexture = preload( "res://ui_scenes/playerHUD/crafting/craftingIcon.png" )
var uncraftableTexture = preload( "res://ui_scenes/playerHUD/crafting/cantCraft.png" )

var parent :Node2D= null

var isCraftable = false

func _ready():
	displayRecipe()
	updateCraftability()
	PlayerData.updateInventory.connect(updateCraftability)
	parent.scannedStations.connect(changeVisibility)

func displayRecipe():
	var itemID :int= recipe.itemToCraft
	var amount :int= recipe.amountToCraft
	
	sprite.texture = ItemData.getItemTexture(itemID)
	amountLabel.text = str( amount )

func updateCraftability():
	var craft = PlayerData.checkIfCraftable(recipe)
	displayCanCraft( craft )

func displayCanCraft(canCraft):
	
	isCraftable = canCraft
	
	changeVisibility()
	
	if canCraft:
		texture = craftableTexture
		sprite.modulate = Color.WHITE
	else:
		texture = uncraftableTexture
		sprite.modulate = Color.BLACK
	
	

func changeVisibility():
	var hasStation = checkForStation()
	var show = isCraftable or parent.showUncraftables
	visible = show and hasStation

func checkForStation():
	if recipe.requiresStation:
		return parent.stationScan.has( recipe.station )
	
	
	return true


func _on_craft_button_pressed():
	
	var itemID :int= recipe.itemToCraft
	var amount :int= recipe.amountToCraft
	
	var hand = PlayerData.getHandSlot()
	
	if hand[0] != -1 and hand[0] != itemID:
		return  # cancel if holding wrong item
	
	if hand[1] + amount > ItemData.getItem(itemID).maxStackSize:
		return # cancel if holding too much of correct item 
	
	if isCraftable:
		if Input.is_action_pressed("shift"):
			var poo = true
			while (poo): # crafts as many as possible
				var canCraftAgain = PlayerData.craftItem(recipe)
				displayCanCraft(canCraftAgain)
				if !canCraftAgain:
					poo = false
		else:
			var canCraftAgain = PlayerData.craftItem(recipe)
			displayCanCraft(canCraftAgain)
		SoundManager.playSound("inventory/pickupItem",get_global_mouse_position(),1.2,0.1)

func _on_craft_button_mouse_entered():
	parent.displayCraftingInfo(recipe)
	var id = recipe.itemToCraft
	var n = ItemData.getItemName(id)
	GlobalRef.hotbar.displayItemName(n,ItemData.getItem(id))


func _on_craft_button_mouse_exited():
	parent.displayCraftingInfo(null)
	GlobalRef.hotbar.displayItemName("",null)
