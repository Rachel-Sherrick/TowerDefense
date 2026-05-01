extends Character
class_name Enemy

@export var final_target_name: String = "Orb"
@export var attack_range: float = 3.0

##initialized by the calling scene
var final_target: Tower
var target_tower: Node3D = null

func _ready() -> void:
	super()
	find_target()

func _physics_process(delta: float) -> void:
	move_or_attack(delta)
	super(delta)

## finds its target by name
func find_target() -> void:
	## finds the target's location
	target_tower = findFirst()
	print("attempting to target", target_tower)
	if target_tower == null or !is_instance_valid(target_tower):
		target_tower = final_target
		print("actually targeting ", target_tower)
		

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
	if !tracking_array.is_empty(): 
		return tracking_array[0]
	else:
		print("Could not find a target")
		return null

func _on_range_detection_body_entered(body: Node3D) -> void:
	## See healer.gd for old code
	#adds the body entering to the front of the array
	print("Enemy detected ", body)
	addTrack(body)
	target_tower = body
	
func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)
	call_deferred("find_target")
