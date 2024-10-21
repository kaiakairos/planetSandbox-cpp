extends Node
var recipies :Array[CraftingRecipe]=[load("res://item_resources/crafting/recipies/Arrow.tres"),load("res://item_resources/crafting/recipies/ArrowGold.tres"),load("res://item_resources/crafting/recipies/ArrowPoisonTipped.tres"),load("res://item_resources/crafting/recipies/BakedPotato.tres"),load("res://item_resources/crafting/recipies/Bed.tres"),load("res://item_resources/crafting/recipies/BowWooden.tres"),load("res://item_resources/crafting/recipies/Bucket.tres"),load("res://item_resources/crafting/recipies/ChairWood.tres"),load("res://item_resources/crafting/recipies/ChestplateCopper.tres"),load("res://item_resources/crafting/recipies/ChestplateGold.tres"),load("res://item_resources/crafting/recipies/ChestplateIron.tres"),load("res://item_resources/crafting/recipies/ChestWood.tres"),load("res://item_resources/crafting/recipies/DoorWood.tres"),load("res://item_resources/crafting/recipies/FishAndChips.tres"),load("res://item_resources/crafting/recipies/FishingRodWooden.tres"),load("res://item_resources/crafting/recipies/Furnace.tres"),load("res://item_resources/crafting/recipies/Glass.tres"),load("res://item_resources/crafting/recipies/Grill.tres"),load("res://item_resources/crafting/recipies/GrilledCatfish.tres"),load("res://item_resources/crafting/recipies/HelmetCopper.tres"),load("res://item_resources/crafting/recipies/HelmetGold.tres"),load("res://item_resources/crafting/recipies/HelmetIron.tres"),load("res://item_resources/crafting/recipies/IngotCopper.tres"),load("res://item_resources/crafting/recipies/IngotGold.tres"),load("res://item_resources/crafting/recipies/IngotIron.tres"),load("res://item_resources/crafting/recipies/Ladder.tres"),load("res://item_resources/crafting/recipies/LeggingsCopper.tres"),load("res://item_resources/crafting/recipies/LeggingsGold.tres"),load("res://item_resources/crafting/recipies/LeggingsIron.tres"),load("res://item_resources/crafting/recipies/LetterBlock.tres"),load("res://item_resources/crafting/recipies/Mallet.tres"),load("res://item_resources/crafting/recipies/PaperBlock.tres"),load("res://item_resources/crafting/recipies/PaperWall.tres"),load("res://item_resources/crafting/recipies/PickaxeCopper.tres"),load("res://item_resources/crafting/recipies/PickaxeGold.tres"),load("res://item_resources/crafting/recipies/PickaxeIron.tres"),load("res://item_resources/crafting/recipies/Soil.tres"),load("res://item_resources/crafting/recipies/StoneBrick.tres"),load("res://item_resources/crafting/recipies/SunflowerPickaxe.tres"),load("res://item_resources/crafting/recipies/SunflowerSword.tres"),load("res://item_resources/crafting/recipies/SwordCopper.tres"),load("res://item_resources/crafting/recipies/SwordGold.tres"),load("res://item_resources/crafting/recipies/SwordIron.tres"),load("res://item_resources/crafting/recipies/Torch.tres"),load("res://item_resources/crafting/recipies/TrapdoorWooden.tres"),load("res://item_resources/crafting/recipies/WallGlass.tres"),load("res://item_resources/crafting/recipies/WallStoneBrick.tres"),load("res://item_resources/crafting/recipies/WallWood.tres"),load("res://item_resources/crafting/recipies/WaxLollipop.tres"),load("res://item_resources/crafting/recipies/WhiteWool.tres"),load("res://item_resources/crafting/recipies/WoolBlack.tres"),load("res://item_resources/crafting/recipies/WoolBlue.tres"),load("res://item_resources/crafting/recipies/WoolBrown.tres"),load("res://item_resources/crafting/recipies/WoolCyan.tres"),load("res://item_resources/crafting/recipies/WoolGreen.tres"),load("res://item_resources/crafting/recipies/WoolGrey.tres"),load("res://item_resources/crafting/recipies/WoolOrange.tres"),load("res://item_resources/crafting/recipies/WoolPink.tres"),load("res://item_resources/crafting/recipies/WoolPurple.tres"),load("res://item_resources/crafting/recipies/WoolRed.tres"),load("res://item_resources/crafting/recipies/WoolYellow.tres"),load("res://item_resources/crafting/recipies/Workbench.tres"),]


func _ready():
	var i:int=0
	for r in recipies:
		r.internalID = i
		for item in r.ingredients:
			ItemData.data[item.ingredient].materialIn.append( i )
		i += 1
