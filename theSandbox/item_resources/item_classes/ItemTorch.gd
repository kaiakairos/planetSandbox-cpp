extends Item
class_name ItemTorch

@export var blockID := 0


func onUse(tileX:int,tileY:int,planetDir:int,planet,lastTile:Vector2):
	
	if planet == null:
		#Cancel if not on planet
		return "failure"
	
	var block = planet.DATAC.getTileData(tileX,tileY)
	
	if ![0,1].has(block):
		#Cancel is target tile isn't empty
		return "failure"
	
	# check down
	var d = Vector2(0,1).rotated((PI/2)*planetDir)
	var downTile = Vector2(tileX,tileY) + Vector2(int(d.x),int(d.y))
	if getBlockIsSolid(planet.DATAC.getTileData(downTile.x,downTile.y)):
		var edit = Vector2i(tileX,tileY)
		planet.DATAC.setInfoData(tileX,tileY,1)
		planet.editTiles({edit:blockID})
		PlayerData.consumeSelected()
		return "success"
	
	# check sides
	var r = Vector2(1,0).rotated((PI/2)*planetDir)
	var rightTile = Vector2(tileX,tileY) + Vector2(int(r.x),int(r.y))
	if getBlockIsSolid(planet.DATAC.getTileData(rightTile.x,rightTile.y)):
		var edit = Vector2i(tileX,tileY)
		planet.DATAC.setInfoData(tileX,tileY,2)
		planet.editTiles({edit:blockID})
		PlayerData.consumeSelected()
		return "success"
	
	var l = Vector2(-1,0).rotated((PI/2)*planetDir)
	var leftTile = Vector2(tileX,tileY) + Vector2(int(l.x),int(l.y))
	if getBlockIsSolid(planet.DATAC.getTileData(leftTile.x,leftTile.y)):
		var edit = Vector2i(tileX,tileY)
		planet.DATAC.setInfoData(tileX,tileY,3)
		planet.editTiles({edit:blockID})
		PlayerData.consumeSelected()
		return "success"
	
	
	# check for bg wall
	var bg = planet.DATAC.getBGData(tileX,tileY)
	if ![0,1].has(bg):
		var edit = Vector2i(tileX,tileY)
		planet.editTiles({edit:blockID})
		planet.DATAC.setInfoData(tileX,tileY,0)
		PlayerData.consumeSelected()
		return "success"

func getBlockIsSolid(id):
	return BlockData.theChunker.getBlockDictionary(id)["hasCollision"]
