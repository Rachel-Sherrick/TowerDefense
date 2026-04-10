extends CharacterBody3D
class_name Character

@onready var health = $Health
@onready var potions = $Potions
@onready var health_component = $Health

#### K = take damage <<< test for potions to actually appear to work..
#### H = heal potion
#### J = defense potion

###############
## Constants ##
###############
const FIRST = 0
const LAST = 1
const CLOSE = 2
const STRONG = 3
const WEAK = 4

#####################
## Storage Objects ##
#####################
var tracking_array : Array[CharacterBody3D] = []

######################
## Global Variables ##
######################
var phys_framecount = 0
@export var speed = 5.0
@export var jump_velocity = 4.5
@export var range_detection = 1
@export var damage = 2
@export var target_type: int = FIRST
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

func get_target_type() -> int:
	return target_type

func set_target_type(type: int) -> bool:
	if (type < 0 && type > 8):
		return false
	target_type = type
	return true

func _ready() -> void:
	if self is Warrior:
		health_component.died.connect(get_tree().current_scene._on_player_died)

func _physics_process(delta: float) -> void:
	set_phys_framecount(get_phys_framecount() + 1)

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()

	if get_phys_framecount() % 4 == 0:
		update_tracking_structures()

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
	if index == -1:
		print(body.name + "does not exist within the array")
		return
	tracking_array[index] = null
	return

func clear_tracking() -> bool:
	if !($RangeDetection.has_overlapping_bodies()):
		return false
	tracking_array.clear()
	print(name + " cleared tracking list")
	return true

func update_tracking_structures() -> bool:
	var obj_list = $RangeDetection.get_overlapping_bodies()
	for body in obj_list:
		print(body.name + " distance from " + name + " is " + str(get_distance_char(body)))
	return true

func _on_range_detection_body_exited(body: Node3D) -> void:
	tracking_array.erase(body)
	trackingArrayManagement()
	print(name + " no longer tracking " + body.name)
	print(tracking_array)

func _on_range_body_entered(body: Node3D) -> void:
	tracking_array.push_front(body)
	trackingArrayManagement()
	print(name + " tracking " + body.name)
	print("Body Entered!")
	print(tracking_array)

func trackingArrayManagement():
	while (tracking_array.size() > 2):
		tracking_array.pop_back()

func take_damage(amount: int) -> void:
	health_component.take_damage(amount)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			potions.use_heal_potion(health)

		if event.keycode == KEY_J:
			potions.use_defense_potion(health)

		if event.keycode == KEY_K:
			health.take_damage(5)
