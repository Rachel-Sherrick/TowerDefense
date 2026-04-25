extends CharacterBody3D
class_name Bullet

const SPEED = 60.0

#this variable needs to be changed I think in order for the
#projectile to go towards the enemy
var target = Vector3(0,0,0)
var attack_damage: int = 1

func _ready() -> void:
	$AnimatedSprite3D.play("travel")

func _physics_process(delta: float) -> void:
	var dir: Vector3 = global_position.direction_to(target)
	$AnimatedSprite3D.rotation.z = (dir.z + -90.0)
	velocity = dir * SPEED
	
	var collision_info = move_and_collide(velocity * delta, false, 0.5, true)
	
	if collision_info:
		print("wizard hit ",collision_info.get_collider())
		check_target_hit(collision_info.get_collider())
	
	## removed so collisions are only handled with one call
	#move_and_slide()
	
	##deletes object if stuck in ground
	if global_position.y <= 0.5:
		queue_free()
	
#if the projectile hit an enemy, delete the enemy & projectile
func check_target_hit(enemy) -> void:
	#check specifically for the CharacterCollsion shape in the characterbody3d?
	#maybe if we change all the enemies' CharacterCollision shape to EnemyCollsion and then check if the name matches?
	#also needs to be changed so that the enemies take multiple hits and player gets coins with each hit
	if enemy is Enemy:
		enemy.take_damage(attack_damage)
	terminate()
	#we need to add a queue free when the projectiles go off the screen

func terminate() -> void:
	set_physics_process(false)
	$AnimatedSprite3D.play("impact")
	await $AnimatedSprite3D.animation_finished
	queue_free()

## deletes the object if not on screen
func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	terminate()
