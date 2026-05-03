extends Tower
class_name Healer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

## Bool to toggle friend tracking
@export var tracking_friends: bool = true

func get_tracking_friends() -> bool:
	return tracking_friends

func _physics_process(delta: float) -> void:
	super(delta)

## updates the structures the object tracks
## by rule of thumb characters do not tracks allies unless toggled
func update_tracking_structures() -> bool:
	var obj_list = $RangeDetection.get_overlapping_bodies()
	## updates the position for all colliding bodies
	for body in obj_list:
		## ignores if the body is self or is part of the same group
		if (body.name != name):
			## Skips if is friend and not allowed to track friends
			if (body.get_groups() == get_groups()) && (!get_tracking_friends()):
				continue
			print(body.name + " distance from " + name + " is " + str(get_distance_char(body)))
			#tracking_dict[body] = get_distance_char(body)
	return true

## clears the tracking data structures of elements
## to prevent them from becoming too large
func clear_tracking() -> bool:
	var obj_list = $RangeDetection.get_overlapping_bodies()
	if !obj_list.is_empty():
		for body in obj_list:
			## ignores if the body is self or is part of the same group
			if (body.name != name):
				## Skips if is friend and allowed to track friends
				if (body.get_groups() == get_groups()) && (get_tracking_friends()):
					continue
				## returns false if the obj_list contains a single non-friend obj
				print(name + " failed to clear tracking list")
				return false
	#tracking_dict.clear()
	tracking_array.clear()
	print(name + " cleared tracking list")
	return true

func _on_range_detection_body_exited(body: Node3D) -> void:
	## When translating the Character and entering scene, 
	## RangeDetection will detect its own Body 
	if (body.name != name):
		## prevents the removal of friends if they couldn't have been added to the
		## the group
		if (body.get_groups() == get_groups()) && (!get_tracking_friends()):
			return
		#tracking_dict.erase(body)
		#remove_char_array(body)
		## Attempts to clear the tracking data structures
		clear_tracking()
		print(name + " no longer tracking " + body.name)

func _on_range_body_entered(body: Node3D) -> void:
	## When translating the Character and entering scene, 
	## RangeDetection will detect its own Body 
	if (body.name != name):
		## Returns if is friend and not allowed to track friends
		if (body.get_groups() == get_groups()) && (!get_tracking_friends()):
			return
		#tracking_dict[body] = get_distance_char(body)
		tracking_array.append(body)
		print(name + " tracking " + body.name)
		return
	return
