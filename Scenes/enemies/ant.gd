extends Enemy
class_name Ant

@onready var hurt_box: Area3D = $AntHurtBox
@onready var attack_interval_timer: Timer = $AntTimer
@onready var animation_controller: Node3D = $AnimationController

var attack_ready : bool = false

func _ready() -> void:
	super()
	animation_controller.play("walk")
	hurt_box.hide()
	attack_interval_timer.wait_time = attack_interval
	attack_interval_timer.start()

func _on_timer_timeout():
	attack_ready = true
	print(name, "'s ATTACK READY")

##handles the attacks
func attack_handler() -> void:
	if (attack_ready == true):
		##prevents animations from getting overwritten
		print("Attack is busy waiting")
		if (animation_controller.get_animation() == "walk" or animation_controller.get_animation() == "idle"): 
			attack_ready = false
			## plays the animation and only deals damage when
			## the attack's wind up is finished
			attack_play_animation()
			await animation_controller.hurt_frame_triggered
			
			## targets an enemy; does not change target if there is no enemy returned
			var enemy_in_range = hurt_box.get_overlapping_bodies()
			#show_hurt_box()
			
			print("Ant is attempting to attack ", enemy_in_range)
			for enemy in enemy_in_range:
				attack_damage_to_enemy(enemy)
			print("Ant's attack complete")
			
			
			##forces attacks to wait till animation is finished till a new one begins
			await animation_controller.animation_finished
			reset_cooldown()

func attack_play_animation() -> void:
	print("Ant is now attacking")
	animation_controller.play("attack")

#dealing warrior sword swing damage to enemies
func attack_damage_to_enemy(enemy: Character) -> void:
	print(name, " attacked ", enemy.name)
	## !! see comments in Character.gd !!
	enemy.take_damage(attack_damage)
	print(enemy.name + " health: ", enemy.get_health())
	
func reset_cooldown() -> void:
	attack_interval_timer.start()
	if velocity == Vector3.ZERO:
		animation_controller.play("idle")
	else:
		animation_controller.play("walk")
	print(name + "'s attack on cooldown")
