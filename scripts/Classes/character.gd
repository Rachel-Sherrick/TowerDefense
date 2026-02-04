extends CharacterBody3D
class_name Character
signal enable_tracking(body : CollisionObject3D)
signal disable_tracking(body : CollisionObject3D)

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

func _on_ray_cast_3d_detect_foe(body: CollisionObject3D) -> void:
	print(name + " detected " + body.name)

func _on_ray_cast_3d_detect_friend(body: CollisionObject3D) -> void:
	print(name + " detected " + body.name)

func _on_range_detection_body_exited(body: Node3D) -> void:
	## When translating the Character adn entering scene, RangeDetection will detect its own Body 
	if (body.name != name):
		print(name + " no longer tracking " + body.name)
		emit_signal("disable_tracking", body)

func _on_range_body_entered(body: Node3D) -> void:
	## When translating the Character adn entering scene, RangeDetection will detect its own Body 
	if (body.name != name):
		print(name + " tracking " + body.name)
		emit_signal("enable_tracking", body)
	else:
		pass
