extends Node

var medalDictionary = {
	"openGame":{
		"icon":"res://ui_scenes/achievements/icons/medal1.png",
		"name":"welcome!",
		"desc":"create your first world!",
		"ngMedal":82862,
	},
	"craftWorkbench":{
		"icon":"res://ui_scenes/achievements/icons/medal2.png",
		"name":"get back to work",
		"desc":"craft a workbench",
		"ngMedal":82863,
	},
	"obtainOre":{
		"icon":"res://ui_scenes/achievements/icons/medal17.png",
		"name":"rock and stone",
		"desc":"obtain your first ore",
		"ngMedal":82916,
	},
	"lootChest":{
		"icon":"res://ui_scenes/achievements/icons/medal3.png",
		"name":"lucky find",
		"desc":"open a loot chest",
		"ngMedal":82864,
	},
	"equipArmor":{
		"icon":"res://ui_scenes/achievements/icons/medal4.png",
		"name":"lookin' good",
		"desc":"equip a piece of armor",
		"ngMedal":82865,
	},
	"equipTrinket":{
		"icon":"res://ui_scenes/achievements/icons/medal5.png",
		"name":"run faster, jump higher",
		"desc":"equip a trinket",
		"ngMedal":82866,
	},
	"fish":{
		"icon":"res://ui_scenes/achievements/icons/medal6.png",
		"name":"how does it fish...",
		"desc":"go fishing",
		"ngMedal":82867,
	},
	"killMimic":{
		"icon":"res://ui_scenes/achievements/icons/medal7.png",
		"name":"unlucky find",
		"desc":"kill a mimic",
		"ngMedal":82869,
	},
	"craftStaff":{
		"icon":"res://ui_scenes/achievements/icons/medal8.png",
		"name":"wizard shit",
		"desc":"craft a staff of any type",
		"ngMedal":82870,
	},
	"findVanity":{
		"icon":"res://ui_scenes/achievements/icons/medal9.png",
		"name":"get dressed",
		"desc":"find a vanity gift and open it",
		"ngMedal":82868,
	},
	"harvestCrop":{
		"icon":"res://ui_scenes/achievements/icons/medal10.png",
		"name":"dude it's just like minecraft !",
		"desc":"grow and harvest a crop",
		"ngMedal":82871,
	},
	
	"findCore":{
		"icon":"res://ui_scenes/achievements/icons/medal11.png",
		"name":"amethyst geode",
		"desc":"dig down until you no longer can",
		"ngMedal":82872,
	},
	"takeFall":{
		"icon":"res://ui_scenes/achievements/icons/medal12.png",
		"name":"yeowch !!",
		"desc":"take 90+ points of fall damage and live",
		"ngMedal":82873,
	},
	"haveMoney":{
		"icon":"res://ui_scenes/achievements/icons/medal13.png",
		"name":"money smart",
		"desc":"have over 1000 money in the bank",
		"ngMedal":82874,
	},
	"defeatPraffin":{
		"icon":"res://ui_scenes/achievements/icons/medal14.png",
		"name":"timmy bigness",
		"desc":"defeat the big praffin",
		"ngMedal":82875,
	},
	"researchStation":{
		"icon":"res://ui_scenes/achievements/icons/medal16.png",
		"name":"i fucking looove science !!!",
		"desc":"create the research station",
		"ngMedal":82876,
	},
	"defeatWorm":{
		"icon":"res://ui_scenes/achievements/icons/medal15.png",
		"name":"worm odyssey",
		"desc":"defeat the giant worm",
		"ngMedal":82877,
	},
	
}

var unlockedmedals :Dictionary= {}

var canvas = CanvasLayer.new()

@onready var popupscene = preload("res://ui_scenes/achievements/medal_unlock_popup.tscn")

func _ready():
	# load saved achievements
	var data = Saving.read_save("medals")
	if data != null:
		unlockedmedals = Saving.read_save("medals")
	
	add_child(canvas)
	
func unlockMedal(medalName:String):
	
	if !medalDictionary.has(medalName):
		print("ERROR: A medal with medal name " + medalName + " doesn't exist!!")
		return
	
	if GlobalRef.cheatsEnabled:
		print("Tried to give achievement, but this world has cheats enabled!")
	
	var medal = medalDictionary[medalName]
	Ngio.request("Medal.unlock", {"id": medal["ngMedal"]})
	# request ng to unlock medal regardless if medal is unlocked locally
	# not efficient but it will make sure if players play on itch first they
	# will still be able to unlock medals
	
	if !unlockedmedals.has(medalName):
		var ins = popupscene.instantiate()
		ins.medalName = medalName
		canvas.add_child(ins)
		unlockedmedals[medalName] = true
		saveMedals()

func saveMedals():
	Saving.write_save("medals",unlockedmedals)

func isMedalUnlocked(medalName) -> bool:
	return unlockedmedals.has(medalName)

func craftingItemUnlocks(itemId:int):
	match itemId:
		20:
			AchievementData.unlockMedal("craftWorkbench")
		129:
			AchievementData.unlockMedal("researchStation")
		3126:
			AchievementData.unlockMedal("craftStaff")
		3127:
			AchievementData.unlockMedal("craftStaff")
		3128:
			AchievementData.unlockMedal("craftStaff")
		3129:
			AchievementData.unlockMedal("craftStaff")
		3180:
			AchievementData.unlockMedal("craftStaff")
