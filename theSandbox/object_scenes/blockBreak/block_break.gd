extends Node2D

var planet = null
var planetDir = 0
var tileX = 0
var tileY = 0
var blockID = 0

var damage = 0

var mineMultiplier := 1.0

var baseRotation = 0

func _ready():
	var blockData = BlockData.theChunker.getBlockDictionary(blockID)
	$blockTexture.texture = blockData["texture"]
	
	if blockData["breakParticleID"] == -1:
		$particles.texture = blockData["texture"]
	else:
		var particleData = BlockData.theChunker.getBlockDictionary(blockData["breakParticleID"])
		$particles.texture = particleData["texture"]
	
	if blockData["connectedTexture"]:
		$blockTexture.hframes = 16
		$blockTexture.frame = BlockData.theChunker.scanBlockOpen(planet.DATAC,tileX,tileY) / 8
		$Sprite.hframes = 16
		$Sprite.frame = $blockTexture.frame
	
	if blockData["rotateTextureToGravity"]:
		$blockTexture.rotation = (PI/2) * planet.getBlockPosition(tileX,tileY)
		baseRotation = $blockTexture.rotation
		$Sprite.rotation = $blockTexture.rotation
		
	$Sprite.texture = blockData["texture"]
	

func _process(delta):
	
	#this shit sucks fix it
	
	if planet == null:
		print_debug("BLOCK BREAK HAS NO PLANET ASSIGNED")
		return
	
	if Input.is_action_pressed("mouse_left"):
		var itemData = ItemData.data[PlayerData.inventory[PlayerData.selectedSlot][0]]
		if itemData is ItemMining:
			damage += delta * itemData.miningMultiplier
			var breakTime = BlockData.theChunker.getBlockDictionary(blockID)["breakTime"]
			$blockTexture.position.x = ((randi() % 3)-1) * (damage / breakTime)
			$blockTexture.position.y = ((randi() % 3)-1) * (damage / breakTime)
			$blockTexture.rotation = baseRotation + ((randi() % 3)-1) * (damage / breakTime) * 0.1
			
			var arrayPosition = (tileX * planet.SIZEINCHUNKS * 8) + tileY
			
			if damage >= breakTime:
				var edit = Vector3(tileX,tileY,0)
				planet.editTiles( { edit: -1 } )
				queue_free()
		else:
			queue_free()
	else:
		queue_free()
	
	var mousePos = to_local(get_global_mouse_position())
	if abs(mousePos.y) > 4:
		queue_free()
	if abs(mousePos.x) > 4:
		queue_free()
