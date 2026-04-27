extends Character
class_name Enemy

@export var final_target_name: String = "Orb"
@export var target_name: String = "Orb"
@export var attack_range: float = 3.0

var target_tower: Node3D = null

func _ready() -> void:
	super()
	_find_target()

func _physics_process(delta: float) -> void:
	if target_tower == null or !is_instance_valid(target_tower):
		_find_target()
		
	_move_or_attack(delta)
	super(delta)
	_find_target()

## finds its target by name
func _find_target() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		target_tower = null
		return
		
	## finds the target's location
	if findFirst() != null:
		pass
		#target_tower = findFirst()
	else:
		target_tower = scene.find_child(final_target_name, true, false) as Tower
		
	#target_tower = scene.find_child(target_name, true, false) as Node3D
	
	##Tries to find its final target if there are no other targets
	#if target_tower == null:
		#target_tower = scene.find_child(final_target_name, true, false) as Node3D

func _move_or_attack(delta: float) -> void:
	if target_tower == null:
		velocity = Vector3.ZERO
		return
		
	var dist := global_position.distance_to(target_tower.global_position)

	##removed due to collision errors
	#if dist <= attack_range or 
	
	if dist <= attack_range or $RangeDetection.overlaps_body(target_tower):
		velocity = Vector3.ZERO
		attack_handler()
		#_attack_timer -= delta
		#if _attack_timer <= 0.0:
			#if target_tower.has_method("take_damage"):
				#target_tower.take_damage(attack_damage)
			#_attack_timer = attack_interval
	else:
		#_attack_timer = 0.0
		print("ANT KEPT MOVING")
		var dir := (target_tower.global_position - global_position).normalized()
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
		velocity.y = 0.0

## to be overwritten by subclasses; handles the attacking of creatures
func attack_handler() -> void:
	pass
	
func findFirst() -> Character: 
	var firstEnemy = null
	if !tracking_array.is_empty(): 
		firstEnemy = tracking_array[0]
	return firstEnemy
