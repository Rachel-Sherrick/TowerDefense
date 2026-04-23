extends Tower
class_name Warrior

@onready var warrior_hurt_box: Area3D = $warrior_hurt_box
@onready var hurt_box_mesh: MeshInstance3D = $warrior_hurt_box/hurt_box_mesh
@onready var warrior_timer: Timer = $WarriorTimer
@onready var animation_controller: Node3D = $AnimationController

signal attack_complete()

#is the cooldown over
var swing_ready : bool = false

func _ready() -> void:
	#on load the hurt box is not visible. the mesh instance is just a visual for the hurt box
	animation_controller.play("idle")
	warrior_hurt_box.hide()
	warrior_timer.start()

func _process(delta: float) -> void:
	#if warrior_timer.is_stopped():
		#print("TIMER NOT WORKING")
	if swing_ready == true && $RangeDetection.has_overlapping_bodies():
		##prevents animations from getting overwritten
		if animation_controller.get_animation() == "idle":  
			attack_handler()
	#if !($RangeDetection.has_overlapping_bodies()):
		#animation_controller.play("idle")

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
	swing_ready = false
	## targets an enemy; does not change target if there is no enemy returned
	attack_alter_area(target())
	var enemy_in_range = warrior_hurt_box.get_overlapping_bodies()
	#show_hurt_box()
	for enemy in enemy_in_range:
		attack_damage_to_enemy(enemy)
	print("Attack complete")
	##forces attacks to wait till animation is finished till a new one begins
	await animation_controller.animation_finished
	reset_cooldown()
	emit_signal("attack_complete")
	

## Handles the animation and the oritentation of an attack
func attack_alter_area(target: Enemy) -> void:
	if target == null:
		return
	var dir = get_direction_to_enemy(target)
	var cardinal = get_cardinal_direction(dir)
	change_attack_direction(cardinal)

#dealing warrior sword swing damage to enemies
func attack_damage_to_enemy(enemy: Enemy) -> void:
	print(name, " attacked ", enemy.name)
	## !! see comments in Character.gd !!
	enemy.take_damage(1)
	print(enemy.name + " health: ", enemy.get_health())

#reset timer and swing ready
func reset_cooldown() -> void:
	warrior_timer.start()
	animation_controller.play("idle")
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
	
## Needs to be altered to access the tracking array 
## Use target() (see character.gd) instead
func get_first_enemy() -> Enemy:
	var first = null
	#30 taken from movement function
	var edge = 30
	var placeholder = 0
	
	for body in $RangeDetection.get_overlapping_bodies():
		var pos = global_position
		if pos < edge && pos > placeholder:
			placeholder = pos
			first = body
	
	return first

## Needs to be altered to access the tracking array 
## Use target() (see character.gd) instead
func get_last_enemy() -> Enemy:
	var last = null
	var edge = -30
	var placeholder = 0
	
	for body in $RangeDetection.get_overlapping_bodies():
		var pos = global_position
		if pos > edge && pos < placeholder:
			placeholder = pos
			last = body
	
	return last
	
func get_direction_to_enemy(enemy: Node3D) -> Vector3:
	return (enemy.global_transform.origin - global_transform.origin).normalized()
	
enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}

func get_cardinal_direction(dir: Vector3) -> int:
	#if the absolute value of x is greater than z then its east to west
	if abs(dir.x) > abs(dir.z):
		if dir.x > 0:
			return Direction.EAST
		else:
			return Direction.WEST
	else:
		if dir.z > 0:
			return Direction.SOUTH
		else:
			return Direction.NORTH
			
func change_attack_direction(direction: int):
	match direction:
		Direction.NORTH:
			warrior_hurt_box.rotation.y = deg_to_rad(180)
			animation_controller.play("swing_north")
			#animation_controller.play("swing")
		Direction.SOUTH:
			warrior_hurt_box.rotation.y = deg_to_rad(0)
			animation_controller.play("swing_south")
			#animation_controller.play("swing")
		Direction.EAST:
			warrior_hurt_box.rotation.y = deg_to_rad(90)
			animation_controller.play("swing_east")
			#animation_controller.play("swing")
		Direction.WEST:
			warrior_hurt_box.rotation.y = deg_to_rad(-90)
			animation_controller.play("swing_west")
			#animation_controller.play("swing")
