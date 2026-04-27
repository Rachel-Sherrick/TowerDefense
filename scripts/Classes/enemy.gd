extends Character
class_name Enemy

@export var final_target_name: String = "Orb"
@export var target_name: String = "Orb"
@export var attack_range: float = 3.0

var target_tower: Node3D = null

func _ready() -> void:
	super()
	find_target()

func _physics_process(delta: float) -> void:
	find_target()
	move_or_attack(delta)
	super(delta)

## finds its target by name
func find_target() -> void:
	var scene := get_tree().current_scene
	if scene == null:
		target_tower = null
		return
		
	## finds the target's location
	## doesnt want to work
	if findFirst() != null:
		pass
		#print("Found a target")
		#target_tower = findFirst()
	else:
		target_tower = scene.find_child(final_target_name, true, false) as Tower

func move_or_attack(delta: float) -> void:
	if target_tower == null:
		velocity = Vector3.ZERO
		return

	if $RangeDetection.overlaps_body(target_tower):
		velocity = Vector3.ZERO
		attack_handler()
	else:
		print("ANT KEPT MOVING")
		var dir := global_position.direction_to(target_tower.global_position)
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

func _on_range_body_entered(body: Node3D) -> void:
	## See healer.gd for old code
	#adds the body entering to the front of the array
	super(body)
	
func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)
