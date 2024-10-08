extends Node

var creatureAmount = 0
var creatureLimit = 50 # max evil mobs

var passiveAmount = 0
var passiveLimit = 15 # max passive mobs

var spawnDelayTick = 0
var spawnDelayThreshold = 500 # spawn rate

var creatures = {
	"praffin": "res://object_scenes/entity/enemy_scenes/praffin/praffin.tscn",
	"butterfly": "res://object_scenes/entity/enemy_scenes/butterfly/butterfly.tscn",
	"fish":"res://object_scenes/entity/enemy_scenes/fish/fish.tscn",
	"firefly":"res://object_scenes/entity/enemy_scenes/firefly/firefly.tscn",
	"evilBird":"res://object_scenes/entity/enemy_scenes/evilBird/evil_bird.tscn",
	"spider":"res://object_scenes/entity/enemy_scenes/spider/spider.tscn",
	"cobble":"res://object_scenes/entity/enemy_scenes/cobble/cobble.tscn",
	"apparition":"res://object_scenes/entity/enemy_scenes/apparition/apparition.tscn",
}

func _physics_process(delta):
	if GlobalRef.currentPlanet == null:
		return
	
	var planet = GlobalRef.currentPlanet
	
	spawnDelayTick += 1
	if spawnDelayTick > spawnDelayThreshold:
		for attempt in range(50):
			var randomTile = pickRandomSpot(planet)
			
			if BlockData.checkForCollision(planet.DATAC.getTileData(randomTile.x,randomTile.y)):
				continue # if random spot is in wall, fail and try again
			
			var floorTile = scanValid(planet,randomTile)
			if floorTile == Vector2i(-10,-10):
				continue # fail if couldn't find valid floor
			
			spawnEnemy(planet,floorTile,determineContext(floorTile,planet))
			spawnDelayTick = 0
			return
		spawnDelayTick = 0
		
		

func determineContext(tile,planet):
	if abs(planet.DATAC.getWaterData(tile.x,tile.y)) > 0.5:
		return 3 # is water
	
	if planet.getSurfaceDistance(tile.x,tile.y) > 20.0:
		return 2 # is cave
	
	if GlobalRef.isNight():
		return 1 # surface night
	return 0 #surface day

func scanValid(planet,tile):
	var floorScan = planet.DATAC.findFloor(tile.x,tile.y,BlockData.theChunker.returnLookup())
	if floorScan == Vector2i(-10,-10):
		return Vector2i(-10,-10)
	
	# check if floor is in non-visible and real chunk
	var chunkkey = Vector2(int(floorScan.x)/8,int(floorScan.y)/8)
	if !planet.chunkDictionary.has(chunkkey):
		return Vector2i(-10,-10) # fail if chunk is unrendered
	
	if isTileOnScreen(floorScan,planet):
		return Vector2i(-10,-10) # fail because tile on screen
	
	var wall = planet.DATAC.getBGData(floorScan.x,floorScan.y)
	if !BlockData.checkIfNatural(wall):
		return Vector2i(-10,-10) # fail to spawn on non natural wall
	return floorScan
	

func spawnEnemy(planet,tile,context):
	
	var data = PlanetTypeInfo.getData(planet.planetType)
	var string = data.getEnemySpawn(context)
	if !creatures.has(string):
		string = "butterfly"
	var ins = load(creatures[string]).instantiate()
	
	if ins.passive:
		if passiveAmount >= passiveLimit:
			ins.queue_free()
			return
		passiveAmount += ins.creatureSlots
	else:
		if creatureAmount >= creatureLimit:
			ins.queue_free()
			return
		creatureAmount += ins.creatureSlots
	
	ins.position = planet.tileToPos(Vector2(tile))
	ins.planet = planet
	#creatureAmount += ins.creatureSlots # add creatures slots
	planet.entityContainer.add_child(ins)


func creatureDeleted(creature):
	if creature.passive:
		passiveAmount -= int(creature.creatureSlots)
		passiveAmount = max(passiveAmount,0)
	else:
		creatureAmount -= int(creature.creatureSlots)
		creatureAmount = max(creatureAmount,0)
	creature.queue_free()

func isTileOnScreen(tile,planet):
	var searchPos = GlobalRef.player.position +  Vector2(0,-40).rotated( (PI/2) * GlobalRef.player.rotated )
	var playerTile = planet.posToTile(searchPos)
	
	if playerTile == null:
		return true
	
	var xRange = abs(tile.x - playerTile.x)
	var yRange = abs(tile.y - playerTile.y)
	
	var rangeMin = Vector2(26,20).rotated( (PI/2) * GlobalRef.player.rotated )
	
	if xRange <= abs(rangeMin.x) and yRange <= abs(rangeMin.y):
		return true


	return false
	
func pickRandomSpot(planet):
	var searchPos = GlobalRef.player.position +  Vector2(0,-40).rotated( (PI/2) * GlobalRef.player.rotated )
	var playerTile = planet.posToTile(searchPos)
	
	if playerTile == null:
		return Vector2.ZERO
	
	
	var spawnRange = Vector2(36,22).rotated( (PI/2) * GlobalRef.player.rotated )
	spawnRange.x = abs(spawnRange.x)
	spawnRange.y = abs(spawnRange.y)
	
	
	var tileX = randi_range(-spawnRange.x,spawnRange.x)
	var tileY = randi_range(-spawnRange.y,spawnRange.y)

	return Vector2(tileX + playerTile.x,tileY + playerTile.y)

func summonCommand(planet,position,string):

	if !creatures.has(string):
		GlobalRef.sendError("Error: Enemy with that name doesn't exist")
		return
	var ins = load(creatures[string]).instantiate()
	ins.position = position
	ins.planet = planet
	creatureAmount += ins.creatureSlots # add creatures slots
	planet.entityContainer.add_child(ins)
	
	GlobalRef.sendChat("Spawned a " + string)
