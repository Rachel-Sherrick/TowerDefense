extends RayCast3D
signal detect_friend(body : CollisionObject3D)
signal detect_foe(body : CollisionObject3D)
#pulls the character3D to access the groups

@onready var characterBody= $".."
#pulls range to filter out characters outside the range
@onready var range_detection : Area3D =  $"../RangeDetection"
var target : Character = null

func _ready() -> void:
	##Defaults the raycast to the radius of the RangeDetection
	var range_radius = $"../RangeDetection/RangeCollision".shape.radius
	target_position.z = range_radius
	set_physics_process(false)
	hide()

func _physics_process(delta) -> void:
	if is_colliding(): 
			#Am I hitting a character or the landscape
			if get_collider() is Character: 
				#what am I hitting
				target = get_collider()
				#Am I hitting a friend or an enemy?
				if target.get_groups() == characterBody.get_groups(): 
					print ("Friend!")
					emit_signal("detect_friend", target)
				else: 
					print ("Enemy!")
					emit_signal("detect_foe", target)
				target_position = to_local(get_collision_point())
	else:
		## Commits processing suicide
		set_physics_process(false)
		hide()

## Sets the raycast to track an object entering RangeDetection
func _on_character_enable_tracking(body: CollisionObject3D) -> void:
		set_physics_process(true)
		show()
		target_position = to_local(body.global_transform.origin)

## Sets the raycast to stop tracking an object
func _on_character_disable_tracking(body: CollisionObject3D) -> void:
	## Rejects the object if it is not the object it is currently tracking
	## This check may be passed up to be handled by character.gd later
	if target_position == to_local(body.global_transform.origin):
		## Returns to defaults
		target_position.z = $"../RangeDetection/RangeCollision".shape.radius
		set_physics_process(false)
		hide()
