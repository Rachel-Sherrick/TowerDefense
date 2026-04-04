extends CharacterBody3D

const SPEED = 250.0

#this variable needs to be changed I think in order for the
#projectile to go towards the enemy
var target = Vector3(0,0,0)

func _physics_process(delta: float) -> void:
	
	var dir = global_position.direction_to(target)
	velocity = dir * SPEED
	
	var collision_info = move_and_collide(velocity * delta, true)
	if collision_info:
		check_target_hit(collision_info.get_collider())

	move_and_slide()
	
#if the projectile hit an enemy, delete the enemy & projectile
func check_target_hit(enemy) -> void:
	enemy.free()
	#increase coins per every hit here?
	queue_free()
	
