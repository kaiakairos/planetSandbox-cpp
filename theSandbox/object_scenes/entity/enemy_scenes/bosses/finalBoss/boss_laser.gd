extends Node2D

var dir :int = 1 # can be 1 or -1

var aliveTime :int = 120

var charged :bool = false

@onready var ray = $RayCast2D
func _ready():
	ray.force_raycast_update()

func _process(delta):
	
	if charged:
		if aliveTime % 2 == 0:
			$Line2D.width = 12
		else:
			$Line2D.width = 8
	else:
		if aliveTime % 2 == 0:
			$Line2D.width = 2
		else:
			$Line2D.width = 0
			
		if aliveTime < 80:
			charged = true
			
			$Hurtbox/CollisionShape2D.call_deferred("set_disabled",false)
	
	aliveTime -= 1
	rotate(dir * 0.8 * delta)
	
	
	var l = 600
	if ray.is_colliding():
		l = to_local(ray.get_collision_point()).length()
	
	$Line2D.points[1].x = l
	$Hurtbox/CollisionShape2D.shape.size.x = l
	$Hurtbox/CollisionShape2D.position.x = l * 0.5
	$CPUParticles2D.position.x = l + 4
	
	
	if aliveTime < 0:
		queue_free()
	
