extends Node

var data = {
	-1:null,
	# block items
	0:load("res://items/blocks/natural/StoneItem.tres"),
	2:load("res://items/blocks/natural/StoneItem.tres"),
	3:load("res://items/blocks/natural/DirtItem.tres"),
	7:load("res://items/blocks/foliage/SaplingItem.tres"),
	13:load("res://items/blocks/building/WoodItem.tres"),
	-13:load("res://items/walls/WoodWallItem.tres"),
	14:load("res://items/blocks/natural/SandItem.tres"),
	15:load("res://items/torches/TorchItem.tres"),
	16:load("res://items/blocks/furniture/stations/Furnace.tres"),
	18:load("res://items/blocks/ores/CopperOre.tres"),
	20:load("res://items/blocks/furniture/stations/WorkBench.tres"),
	21:load("res://items/blocks/building/GlassItem.tres"),
	-21:load("res://items/walls/GlassWallItem.tres"),
	24:load("res://items/blocks/ores/GoldOre.tres"),
	25:load("res://items/blocks/furniture/other/Ladder.tres"),
	26:load("res://items/blocks/foliage/flowers/LilyItem.tres"),
	27:load("res://items/blocks/ores/IronOre.tres"),
	28:load("res://items/blocks/natural/GravelItem.tres"),
	
	29:load("res://items/material/bars/CopperBar.tres"),
	30:load("res://items/material/bars/GoldBar.tres"),
	31:load("res://items/material/bars/IronBar.tres"),
	
	32:load("res://items/blocks/building/StoneBrick.tres"),
	-32:load("res://items/walls/StoneBrickWall.tres"),
	
	# item ids
	3000:load("res://items/tools/flimsy/FlimsySword.tres"), # flimsy tools
	3001:load("res://items/tools/flimsy/FlimsyPickaxe.tres"),
	3002:load("res://items/tools/hammers/Mallet.tres"),
	
	3003:load("res://items/material/Wax.tres"),
	3004:null,
	3005:null,
	
	3006:load("res://items/tools/copper/CopperSword.tres"), # copper tools
	3007:load("res://items/tools/copper/CopperPickaxe.tres"),
	
	3008:load("res://items/tools/golden/GoldenSword.tres"), # golden tools
	3009:load("res://items/tools/golden/GoldenPickaxe.tres"),
	
	3010:load("res://items/vanity/redTie/RedTie.tres"),
	3011:load("res://items/tools/iron/IronSword.tres"), # iron tools
	3012:load("res://items/tools/iron/IronPickaxe.tres"),
	
	3013:load("res://items/armors/copper/CopperHelmet.tres"),
	3014:load("res://items/armors/copper/CopperChestplate.tres"),
	3015:load("res://items/armors/copper/CopperLegs.tres"),
	
	3019:load("res://items/armors/iron/IronHelmet.tres"),
	3020:load("res://items/armors/iron/IronChest.tres"),
	3021:load("res://items/armors/iron/IronLeggings.tres"),
	
	3022:load("res://items/vanity/butterflyPin/PinkBFPin.tres"),
	
	# chairs 6000 - 6049
	6000:load("res://items/blocks/furniture/chairs/WoodenChair.tres"),
	6001:load("res://items/blocks/furniture/chairs/Toilet.tres"),
	
	# doors 6050 - 6099
	6050:load("res://items/blocks/furniture/doors/WoodDoor.tres"),
	6051:load("res://items/tools/golden/GoldenPickaxe.tres"),
	
	# chests 6100 - 6200
	6100:load("res://items/blocks/furniture/chests/WoodenChest.tres"),
}

var heldItemAnims = {
	"itemSwing" : load("res://item_resources/item_held_scenes/item_swing.tscn"),
}

func matchItemAnimation(id):
	var d = getItem(id)
	if d is ItemDamage:
		return "itemSwing"
	
	return null

func getItem(id):
	if data.has(id):
		return data[id]
	return data[0]

func itemExists(id):
	return data.has(id)

func getItemName(id):
	var data = getItem(id)
	if !is_instance_valid(data):
		return ""
	return data.itemName


