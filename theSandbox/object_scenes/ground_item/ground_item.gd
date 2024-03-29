extends CharacterBody2D
class_name GroundItem

@onready var texture = $textureRoot/texture
@onready var back = $textureRoot/back

@onready var tint = $textureRoot/texture/tint

var rotSide = 0

var gravity = 600

var itemID = 0
var amount = 1
var maxAmount = 99

var ticks = 0

var tweening = false

var body

func _ready():
	var itemData = ItemData.getItem(itemID)
	
	var img = itemData.texture.get_image()
	img.resize(int(img.get_width()*0.75),int(img.get_height()*0.75),0)
	
	texture.texture = ImageTexture.create_from_image(img)
	back.texture = texture.texture
	maxAmount = itemData.maxStackSize
	
	if !itemData is ItemBlock:
		texture.material = null
	
	var randVelocity = Vector2(randi_range(-70,70),-60)
	rotSide = getPlanetPosition()
	velocity = randVelocity.rotated(rotSide*(PI/2))
	
	body = get_parent().get_parent()
	
	determineAmount()
	
func _process(delta):
	
	if tweening:
		return
	
	ticks += 1 * delta * 80.0
	rotSide = getPlanetPosition()
	
	var newVelocity = velocity.rotated(-rotSide*(PI/2))
	newVelocity.x = lerp(newVelocity.x,0.0,10.0*delta)
	newVelocity.y += gravity * delta
	newVelocity.y = min(newVelocity.y,150)
	velocity = newVelocity.rotated(rotSide*(PI/2))
	
	move_and_slide()
	
	$textureRoot.rotation = rotSide*(PI/2)
	
	texture.offset.y = (sin(ticks*0.12) * 2.0) - 2
	back.offset.y = texture.offset.y
	
func getPlanetPosition():
	if !is_instance_valid(body):
		return 0
	var p = body.posToTile(position)
	if p == null:
		var angle1 = Vector2(1,1)
		var angle2 = Vector2(-1,1)
		
		var dot1 = int(position.dot(angle1) >= 0)
		var dot2 = int(position.dot(angle2) > 0) * 2
		
		return [0,1,3,2][dot1 + dot2]
	return body.DATAC.getPositionLookup(p.x,p.y)

func _on_area_2d_body_entered(body):
	
	if tweening:
		return
	tweenAndDestroy(body.position,true)


func _on_stack_body_entered(body):
	
	## Stack with items of same type ##
	
	if tweening or body == self:
		return

	if body is GroundItem:
		if body.itemID != itemID or body.tweening:
			return
		if body.ticks > ticks:
			if amount + body.amount > maxAmount: return
			amount += body.amount
			determineAmount()
			body.tweenAndDestroy(position,false)
			return

func determineAmount():
	if amount > 1:
		tint.color.a = (amount - 1) * 0.05

func tweenAndDestroy(pos,shouldAddItem):
	if tweening:
		return
	tweening = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",pos,0.1)
	await tween.finished
	
	if shouldAddItem:
		if PlayerData.addItem(itemID,amount) == 0:
			queue_free()
	else:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
