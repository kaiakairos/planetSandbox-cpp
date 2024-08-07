extends Area2D
class_name Hitbox

@export var healthComponent :HealthComponent = null

@export var enemyBox :bool = true
@export var invincTime :float = 0.0

@export var colliderShape :CollisionShape2D = null

var collectedIDs = []

var invincible = false

func _ready():
	if healthComponent == null:
		print("Error, entity has no health component")
		queue_free()
	if colliderShape == null:
		print("Error, entity has no hitbox collision shape")
		queue_free()

func _on_area_entered(area):
	#check for invalid area
	if !area is Hurtbox:
		return
	if enemyBox == area.enemyBox:
		return
	if collectedIDs.has(area.id) and enemyBox:
		return
	if invincible:
		return
		
	#is now valid hurtbox
	
	# get dir for knockback
	var dir = global_position - area.global_position
	
	collectedIDs.append(area.id)
	
	healthComponent.damage(area.damage)
	healthComponent.dealKnockback(120.0,dir)
	area.hasHit()
	
	colliderShape.call_deferred("set_disabled",true)
	invincible = true
	await get_tree().process_frame
	
	if invincTime > 0.0:
		await get_tree().create_timer(invincTime).timeout
	colliderShape.call_deferred("set_disabled",false)
	invincible = false
	
	if collectedIDs.size() > 3:
		collectedIDs.remove_at(0)
	
