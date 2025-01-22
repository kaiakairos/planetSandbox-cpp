extends Node
var recipies :Array[CraftingRecipe]=[load("res://item_resources/crafting/recipies/Arrow.tres"),load("res://item_resources/crafting/recipies/ArrowGold.tres"),load("res://item_resources/crafting/recipies/ArrowPoisonTipped.tres"),load("res://item_resources/crafting/recipies/BakedPotato.tres"),load("res://item_resources/crafting/recipies/Bed.tres"),load("res://item_resources/crafting/recipies/Bonemeal.tres"),load("res://item_resources/crafting/recipies/Book.tres"),load("res://item_resources/crafting/recipies/BowWooden.tres"),load("res://item_resources/crafting/recipies/BreadSlice.tres"),load("res://item_resources/crafting/recipies/BreakfastSandwich.tres"),load("res://item_resources/crafting/recipies/Brick.tres"),load("res://item_resources/crafting/recipies/BrickWall.tres"),load("res://item_resources/crafting/recipies/BrownBrick.tres"),load("res://item_resources/crafting/recipies/BrownBrickWall.tres"),load("res://item_resources/crafting/recipies/Bucket.tres"),load("res://item_resources/crafting/recipies/Chain.tres"),load("res://item_resources/crafting/recipies/ChairWood.tres"),load("res://item_resources/crafting/recipies/ChestplateCopper.tres"),load("res://item_resources/crafting/recipies/ChestplateFiber.tres"),load("res://item_resources/crafting/recipies/ChestplateGold.tres"),load("res://item_resources/crafting/recipies/ChestplateIron.tres"),load("res://item_resources/crafting/recipies/ChestWood.tres"),load("res://item_resources/crafting/recipies/ClayWall.tres"),load("res://item_resources/crafting/recipies/Clock.tres"),load("res://item_resources/crafting/recipies/Conveyor.tres"),load("res://item_resources/crafting/recipies/DoorWood.tres"),load("res://item_resources/crafting/recipies/Drill.tres"),load("res://item_resources/crafting/recipies/Extender.tres"),load("res://item_resources/crafting/recipies/FiberBow.tres"),load("res://item_resources/crafting/recipies/FishAndChips.tres"),load("res://item_resources/crafting/recipies/FishingRodWooden.tres"),load("res://item_resources/crafting/recipies/FlowerPot.tres"),load("res://item_resources/crafting/recipies/Furnace.tres"),load("res://item_resources/crafting/recipies/Glass.tres"),load("res://item_resources/crafting/recipies/GrandFatherClock.tres"),load("res://item_resources/crafting/recipies/Grill.tres"),load("res://item_resources/crafting/recipies/GrilledCatfish.tres"),load("res://item_resources/crafting/recipies/HelmetCopper.tres"),load("res://item_resources/crafting/recipies/HelmetFiber.tres"),load("res://item_resources/crafting/recipies/HelmetGold.tres"),load("res://item_resources/crafting/recipies/HelmetIron.tres"),load("res://item_resources/crafting/recipies/Hopper.tres"),load("res://item_resources/crafting/recipies/IngotCopper.tres"),load("res://item_resources/crafting/recipies/IngotGold.tres"),load("res://item_resources/crafting/recipies/IngotIron.tres"),load("res://item_resources/crafting/recipies/JarFirefly.tres"),load("res://item_resources/crafting/recipies/Ladder.tres"),load("res://item_resources/crafting/recipies/LadderPack.tres"),load("res://item_resources/crafting/recipies/LampElectric.tres"),load("res://item_resources/crafting/recipies/Lantern.tres"),load("res://item_resources/crafting/recipies/LeggingsCopper.tres"),load("res://item_resources/crafting/recipies/LeggingsFiber.tres"),load("res://item_resources/crafting/recipies/LeggingsGold.tres"),load("res://item_resources/crafting/recipies/LeggingsIron.tres"),load("res://item_resources/crafting/recipies/LetterBlock.tres"),load("res://item_resources/crafting/recipies/Lever.tres"),load("res://item_resources/crafting/recipies/MagicDinner.tres"),load("res://item_resources/crafting/recipies/MagicInfuser.tres"),load("res://item_resources/crafting/recipies/MagicMirror.tres"),load("res://item_resources/crafting/recipies/Mallet.tres"),load("res://item_resources/crafting/recipies/MarbleBrick.tres"),load("res://item_resources/crafting/recipies/MarbleBrickWall.tres"),load("res://item_resources/crafting/recipies/MarblePillar.tres"),load("res://item_resources/crafting/recipies/Observer.tres"),load("res://item_resources/crafting/recipies/PaperBlock.tres"),load("res://item_resources/crafting/recipies/PaperWall.tres"),load("res://item_resources/crafting/recipies/PickaxeCopper.tres"),load("res://item_resources/crafting/recipies/PickaxeFiber.tres"),load("res://item_resources/crafting/recipies/PickaxeFossil.tres"),load("res://item_resources/crafting/recipies/PickaxeGold.tres"),load("res://item_resources/crafting/recipies/PickaxeIron.tres"),load("res://item_resources/crafting/recipies/Placer.tres"),load("res://item_resources/crafting/recipies/PoachedEgg.tres"),load("res://item_resources/crafting/recipies/Repeater.tres"),load("res://item_resources/crafting/recipies/SandstoneWall.tres"),load("res://item_resources/crafting/recipies/Shelf.tres"),load("res://item_resources/crafting/recipies/Snow.tres"),load("res://item_resources/crafting/recipies/SnowBrick.tres"),load("res://item_resources/crafting/recipies/SnowBrickWall.tres"),load("res://item_resources/crafting/recipies/Soil.tres"),load("res://item_resources/crafting/recipies/SolderingIron.tres"),load("res://item_resources/crafting/recipies/Spitter.tres"),load("res://item_resources/crafting/recipies/StaffBounce.tres"),load("res://item_resources/crafting/recipies/StaffFirebolt.tres"),load("res://item_resources/crafting/recipies/StaffWaterbolt.tres"),load("res://item_resources/crafting/recipies/StaffZeus.tres"),load("res://item_resources/crafting/recipies/StoneBrick.tres"),load("res://item_resources/crafting/recipies/SunflowerPickaxe.tres"),load("res://item_resources/crafting/recipies/SunflowerSword.tres"),load("res://item_resources/crafting/recipies/SwordCopper.tres"),load("res://item_resources/crafting/recipies/SwordFiber.tres"),load("res://item_resources/crafting/recipies/SwordFossil.tres"),load("res://item_resources/crafting/recipies/SwordGold.tres"),load("res://item_resources/crafting/recipies/SwordIron.tres"),load("res://item_resources/crafting/recipies/Table.tres"),load("res://item_resources/crafting/recipies/Torch.tres"),load("res://item_resources/crafting/recipies/TrapdoorWooden.tres"),load("res://item_resources/crafting/recipies/TrinketDefensiveShield.tres"),load("res://item_resources/crafting/recipies/TrinketDiceSet.tres"),load("res://item_resources/crafting/recipies/TrinketGoldenFeather.tres"),load("res://item_resources/crafting/recipies/TrinketJackhammer.tres"),load("res://item_resources/crafting/recipies/TrinketSickKicks.tres"),load("res://item_resources/crafting/recipies/TrinketSnakeEyes.tres"),load("res://item_resources/crafting/recipies/TrinketSuperKicks.tres"),load("res://item_resources/crafting/recipies/TrinketTable.tres"),load("res://item_resources/crafting/recipies/WallGlass.tres"),load("res://item_resources/crafting/recipies/WallStoneBrick.tres"),load("res://item_resources/crafting/recipies/WallWood.tres"),load("res://item_resources/crafting/recipies/WaxLollipop.tres"),load("res://item_resources/crafting/recipies/WhiteWool.tres"),load("res://item_resources/crafting/recipies/Wire.tres"),load("res://item_resources/crafting/recipies/WireBrick.tres"),load("res://item_resources/crafting/recipies/WireBrownbrick.tres"),load("res://item_resources/crafting/recipies/WireDirt.tres"),load("res://item_resources/crafting/recipies/WireSandstone.tres"),load("res://item_resources/crafting/recipies/WireStone.tres"),load("res://item_resources/crafting/recipies/WireStonebrick.tres"),load("res://item_resources/crafting/recipies/WireWood.tres"),load("res://item_resources/crafting/recipies/WoolBlack.tres"),load("res://item_resources/crafting/recipies/WoolBlue.tres"),load("res://item_resources/crafting/recipies/WoolBrown.tres"),load("res://item_resources/crafting/recipies/WoolCyan.tres"),load("res://item_resources/crafting/recipies/WoolGreen.tres"),load("res://item_resources/crafting/recipies/WoolGrey.tres"),load("res://item_resources/crafting/recipies/WoolOrange.tres"),load("res://item_resources/crafting/recipies/WoolPink.tres"),load("res://item_resources/crafting/recipies/WoolPurple.tres"),load("res://item_resources/crafting/recipies/WoolRed.tres"),load("res://item_resources/crafting/recipies/WoolYellow.tres"),load("res://item_resources/crafting/recipies/Workbench.tres"),]


func _ready():
	var i:int=0
	for r in recipies:
		r.internalID = i
		for item in r.ingredients:
			ItemData.data[item.ingredient].materialIn.append( i )
		i += 1
