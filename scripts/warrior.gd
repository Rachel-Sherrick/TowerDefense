extends Tower
class_name Warrior

@onready var warrior_hurt_box: Area3D = $warrior_hurt_box
@onready var hurt_box_mesh: MeshInstance3D = $warrior_hurt_box/hurt_box_mesh
@onready var warrior_timer: Timer = $WarriorTimer
@onready var animation_controller: Node3D = $AnimationController



#is the cooldown over
var swing_ready : bool = false

func _ready() -> void:
	#on load the hurt box is not visible. the mesh instance is just a visual for the hurt box
	warrior_hurt_box.hide()
	warrior_timer.start()

func _process(delta: float) -> void:
	#if warrior_timer.is_stopped():
		#print("TIMER NOT WORKING")
	if swing_ready == true && $RangeDetection.has_overlapping_bodies():
		await attack_handler()
	if !($RangeDetection.has_overlapping_bodies()):
		animation_controller.play("idle")

func _physics_process(delta: float) -> void:
	super(delta)

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)
	#if swing_ready:
	#	attack_handler()
	
func _on_timer_timeout():
	swing_ready = true
	print(name, "'s ATTACK READY")

##handles the attacking of enemies
func attack_handler() -> void:
		reset_cooldown()
		var enemy_in_range = warrior_hurt_box.get_overlapping_bodies()
		## targets an enemy; does not change target if there is no enemy returned
		attack_alter_area(target())
		show_hurt_box()
		for enemy in enemy_in_range:
			attack_damage(enemy)
		##forces attacks to wait till animation is finished till a new one begins
		await animation_controller.animation_finished

## Handles the animation and the oritentation of an attack
func attack_alter_area(target: Enemy) -> void:
	if target == null:
		return
	var dir = get_direction_to_enemy(target)
	var cardinal = get_cardinal_direction(dir)
	change_attack_direction(cardinal)

#dealing warrior sword swing damage to enemies
func attack_damage(enemy: Enemy) -> void:
	print(name, " attacked ", enemy.name)
	## !! see comments in Character.gd !!
	enemy.take_damage(1)
	print(enemy.name + " health: ", enemy.get_health())

#reset timer and swing ready
func reset_cooldown() -> void:
	warrior_timer.start()
	swing_ready = false
	print(name + "'s attack on cooldown")

#show hurt box for 1 second when the warrior swings
func show_hurt_box() -> void:
	warrior_hurt_box.show()
	print(name + "'s hurt box shown")
	## this line will wait 3 sec before proceeding to the next
	## altered to wait for the animation to finish
	await get_tree().create_timer(0.5).timeout
	warrior_hurt_box.hide()
	print(name + "'s hurt box hidden")
	
func target():
	match get_target_type():
		## targeting specfics could be handled by sub functions
		##Warrier specific targeting goes here.
		FIRST:
			pass
			
		LAST:
			pass
		_:
			return false	
