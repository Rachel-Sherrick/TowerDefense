extends CharacterBody3D
class_name Character
##signal enable_tracking(body : CollisionObject3D)
##signal disable_tracking(body : CollisionObject3D)

var tracking_distance: Dictionary[RayCast3D, float] = {}
var tracking_object: Dictionary[Node3D, RayCast3D] = {}

@onready var raycast_scene: PackedScene = preload("res://ray_cast_3d.tscn")

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


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func create_raycast(character: Node3D) -> RayCast3D:
	var raycast = raycast_scene.instantiate()
	add_child(raycast)
	raycast.connect("detect_foe", _on_ray_cast_3d_detect_foe)
	raycast.connect("detect_friend", _on_ray_cast_3d_detect_friend)
	##connect("_on_ray_cast_3d_detect_foe", raycast.detect_foe)
	##connect("_on_ray_cast_3d_detect_friend", raycast.detect_friend)
	raycast.enable_tracking(character)
	return raycast

func _on_ray_cast_3d_detect_foe(body: CollisionObject3D) -> void:
	print(name + " detected foe " + body.name)

func _on_ray_cast_3d_detect_friend(body: CollisionObject3D) -> void:
	print(name + " detected friend " + body.name)

func _on_range_detection_body_exited(body: Node3D) -> void:
	## When translating the Character and entering scene, RangeDetection will detect its own Body 
	if (body.name != name):
		var raycast = tracking_object[body]
		tracking_object.erase(body)
		raycast.disable_tracking(body)
		tracking_distance.erase(raycast)
		print(name + " no longer tracking " + body.name)

func _on_range_body_entered(body: Node3D) -> void:
	## When translating the Character adn entering scene, RangeDetection will detect its own Body 
	if (body.name != name):
		var raycast = create_raycast(body)
		tracking_object[body] = raycast
		tracking_distance[raycast] = raycast.target_position.length()
		print(name + " tracking " + body.name)
	else:
		pass
