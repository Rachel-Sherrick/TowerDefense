extends CharacterBody3D
class_name Character

@onready var health_component = $Health
@onready var potions = $Potions
#### K = take damage <<< test for potions to actually appear to work.. 
#### H = heal potion
#### J = defense potion
#### D = take damage <<< test for potions to actually appear to work..


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
## first (0) is the newest body to enter
var tracking_array : Array[CharacterBody3D] 

var currentTarget

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
@export var damage = 1
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

func set_health(health_lost: int) -> bool:
	if health_component.set_current_health(health_lost):
		return true
	return false
	
##returns target_type
func get_target_type() -> int:
	return target_type

## sets targest type bases on the int provided
func set_target_type(type: int) -> bool:
	if (type < 0 || type >= 5):
		return false
	target_type = type
	return true

func _ready() -> void:
	if self is Warrior:
		health_component.died.connect(get_tree().current_scene._on_player_died)

func _physics_process(_delta: float) -> void:
	set_phys_framecount(get_phys_framecount() + 1)
	## DEBUG LINE: print(get_phys_framecount())
	
	
	move_and_slide()
	
	## updates body positions every 4 frames
	if get_phys_framecount() % 4 == 0:
		update_tracking_structures()


##Use this to get the distance of a character
func get_distance_char(body: Node3D) -> float:
	return to_local(body.global_transform.origin).length()



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
	
	return true
	

func _on_range_detection_body_exited(body: Node3D) -> void:
	##See healer.gd for old code
	
	removeTrack(body)
	print(name + " no longer tracking " + body.name)
	print(tracking_array)
	
func _on_range_body_entered(body: Node3D) -> void:
	## See healer.gd for old code
	#adds the body entering to the front of the array
	addTrack(body)
	print(tracking_array) 


func addTrack(body):
		if !tracking_array.has(body): 
			tracking_array.push_front(body)
		
func removeTrack(body): 
	if tracking_array.has(body): 
		tracking_array.erase(body)

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			potions.use_heal_potion(health_component)
		if event.keycode == KEY_J:
			potions.use_defense_potion(health_component)

		if event.keycode == KEY_K:
			health_component.take_damage(10)
	
func heal(amount: int) -> void:
	if health_component == null:
		print("Heal failed: no health component")
		return

	var before = health_component.current_health
	health_component.heal(amount)
	var after = health_component.current_health

	print(name, " healed +", after - before, " | Current health: ", after)
