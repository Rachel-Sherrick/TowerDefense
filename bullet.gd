extends CharacterBody3D

const SPEED = 50.0

#this variable needs to be changed I think in order for the
#projectile to go towards the enemy
var target = Vector3(0,0,0)

func _physics_process(delta: float) -> void:
	
	var dir = global_position.direction_to(target)
	velocity = dir * SPEED
	
	var collision_info = move_and_collide(velocity * delta, true)
	if collision_info:
		print("wizard hit ",collision_info.get_collider())
		check_target_hit(collision_info.get_collider())

	move_and_slide()
	
#if the projectile hit an enemy, delete the enemy & projectile
func check_target_hit(enemy) -> void:
	#check specifically for the CharacterCollsion shape in the characterbody3d?
	#maybe if we change all the enemies' CharacterCollision shape to EnemyCollsion and then check if the name matches?
	#also needs to be changed so that the enemies take multiple hits and player gets coins with each hit
	if enemy is Enemy:
		enemy.free()
	queue_free()
	#we need to add a queue free when the projectiles go off the screen
