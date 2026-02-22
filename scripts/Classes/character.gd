extends CharacterBody3D
class_name Character

###############
## Constants ##
###############
## Targeting constants
const FIRST = 0
const LAST = 1
const CLOSE = 2
const STRONG = 3
const WEAK = 4

#####################
## Storage Objects ##
#####################

## data structures for tracking chracters within the range
# need to add functions to empty array and map if there are no non
# null elements
var tracking_dict: Dictionary[Node3D, float] = {}
var tracking_array = []

######################
## Global Variables ##
######################
## !!ONLY ACCESS THROUGH SETTERS AND GETTERS IN MOST CASES!! ##

## frame trackers
var phys_framecount = 0
## Movement speed multiplier for the character 
@export var speed = 5.0
## Veloicty for when / if the chracter jumps
@export var jump_velocity = 4.5
## Health for when the character gets attacked
@export var health = 1
## Range multiplier for the character's range
## Only set range through RangeDetection's set_range
@export var range_detection = 1
## Damage multiplier for when the character deals damage to another character
@export var damage = 1
## The default targeting priority
@export var target_type: int = FIRST

#########################
## Functions & Methods ##
#########################

func get_phys_framecount() -> int:
	return phys_framecount

func set_phys_framecount(new_count: int) -> bool:
	if new_count > 60:
		phys_framecount = 1
		return false
	phys_framecount = new_count
	return true

func get_target_type() -> int:
	return target_type

func set_target_type(type: int) -> bool:
	if (type < 0 && type > 8):
		return false
	target_type = type
	return true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	set_phys_framecount(get_phys_framecount() + 1)
	## DEBUG LINE: print(get_phys_framecount())
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		
	move_and_slide()
	
	## updates body positions every 4 frames
	if get_phys_framecount() % 4 == 0:
		update_tracking_structures()

## function to be overridden by children; handles the targeting
## of chracters for attacks. 
## this serves only as a potential example
func target(body: Node3D) -> bool:
	match get_target_type():
		## targeting specfics could be handled by sub functions
		FIRST:
			print(name + " targeted " + body.name + " with First")
			return true
		LAST:
			print(name + " targeted " + body.name + " with Last")
			return true
		_:
			return false	

func get_distance_char(body: Node3D) -> float:
	return to_local(body.global_transform.origin).length()

func remove_char_array(body: Node3D) -> void:
	var index = tracking_array.find(body)
	## this means that the body was not found
	if index == -1:
		print(body.name + "does not exist within the array")
		return
	tracking_array[index] = null
	return 

## clears the tracking data structures of elements
## to prevent them from becoming too large
func clear_tracking() -> bool:
	## See healer.gd for old code
	if !($RangeDetection.has_overlapping_bodies()):
		return false
	tracking_dict.clear()
	tracking_array.clear()
	print(name + " cleared tracking list")
	return true

## updates the structures the object tracks
## by rule of thumb characters do not tracks allies unless toggled
func update_tracking_structures() -> bool:
	var obj_list = $RangeDetection.get_overlapping_bodies()
	## updates the position for all colliding bodies
	for body in obj_list:
		## See healer.gd for old code
		print(body.name + " distance from " + name + " is " + str(get_distance_char(body)))
		tracking_dict[body] = get_distance_char(body)
	return true

func _on_range_detection_body_exited(body: Node3D) -> void:
	##See healer.gd for old code
	tracking_dict.erase(body)
	remove_char_array(body)
	## Attempts to clear the tracking data structures
	clear_tracking()
	print(name + " no longer tracking " + body.name)

func _on_range_body_entered(body: Node3D) -> void:
	## See healer.gd for old code
	tracking_dict[body] = get_distance_char(body)
	tracking_array.append(body)
	print(name + " tracking " + body.name)
