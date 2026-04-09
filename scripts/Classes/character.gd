extends CharacterBody3D
class_name Character

@onready var health = $Health
@onready var potions = $Potions
#### K = take damage <<< test for potions to actually appear to work.. 
#### H = heal potion
#### J = defense potion


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
# !! replace tracking_dict with a sorted array !!
# var tracking_dict: Dictionary[Node3D, float] = {}
# !! make sure this array only has up two elements, with the first representing
# the last body to enter and the second representing the newest !!
var tracking_array : Array[CharacterBody3D] = []

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
## Range multiplier for the character's range
## Only set range through RangeDetection's set_range
@export var range_detection = 1
## Damage multiplier for when the character deals damage to another character
@export var damage = 5
## The default targeting priority
@export var target_type: int = FIRST
## Arbitrary definition for strength for targeting
@export var strength: int = 0

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
	
func get_health() -> int:
	return health_component.current_health

## !! Change so that health	
func set_health(health_lost: int) -> bool:
	if health_component.set_current_health(health_lost):
		return true
	return false
	
func get_target_type() -> int:
	return target_type

func set_target_type(type: int) -> bool:
	if (type < 0 && type > 8):
		## !! insert code to toggle how the sorted array sorts
		## between distance and strength here !!
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

## Returns a character from one of the arrays using the given targeting_type
func target() -> Character:
	match get_target_type():
		FIRST:
			return tracking_array.front()
		LAST:
			return tracking_array.back()
		_:
			return null

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
	#tracking_dict.clear()
	tracking_array.clear()
	print(name + " cleared tracking list")
	return true

## updates the structures the object tracks
## by rule of thumb characters do not tracks allies unless toggled
func update_tracking_structures() -> bool:
	## updates the position for all colliding bodies
	var obj_list = $RangeDetection.get_overlapping_bodies()
	## !! remove the for loop below and replace with a call to sort
	## the distance / strength array using the Array's built-in sort_custom()!!
	for body in obj_list:
		## See healer.gd for old code
		print(body.name + " distance from " + name + " is " + str(get_distance_char(body)))
		#tracking_dict[body] = get_distance_char(body)
	return true
	

func _on_range_detection_body_exited(body: Node3D) -> void:
	##See healer.gd for old code
	#tracking_dict.erase(body)
	#remove_char_array(body)
	tracking_array.erase(body)
	trackingArrayManagement()
	print(name + " no longer tracking " + body.name)
	print(tracking_array)
	
func _on_range_body_entered(body: Node3D) -> void:
	## See healer.gd for old code
	# tracking_dict[body] = get_distance_char(body)
	#adds the body entering to the front of the array
	tracking_array.push_front(body)
	trackingArrayManagement()
	print(name + " tracking " + body.name)
	print("Body Entered!")
	print(tracking_array) 

##Making sure the array is only two long
func trackingArrayManagement(): 
	while (tracking_array.size() > 2): 
		tracking_array.pop_back()

##H.S added to get health to work properly
@onready var health_component = $Health

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)



func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			potions.use_heal_potion(health)

		if event.keycode == KEY_J:
			potions.use_defense_potion(health)

		if event.keycode == KEY_K:
			health.take_damage(10)
