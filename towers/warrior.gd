extends Tower
class_name Warrior

@onready var warrior_hurt_box: Area3D = $warrior_hurt_box
@onready var hurt_box_mesh: MeshInstance3D = $warrior_hurt_box/hurt_box_mesh
@onready var warrior_timer: Timer = $WarriorTimer
@onready var animation_controller: Node3D = $AnimationController



#is the cooldown over
var swing_ready : bool = false

func _ready() -> void:
	#on load the hurt box is not visible. the mesh instance is just a visual for the hurt box
	warrior_hurt_box.hide()
	warrior_timer.start()

func _process(delta: float) -> void:
	#if warrior_timer.is_stopped():
		#print("TIMER NOT WORKING")
	if swing_ready == true && $RangeDetection.has_overlapping_bodies():
		show_hurt_box()
		var enemy_in_range = warrior_hurt_box.get_overlapping_bodies()
		## also add call to target a specific enemy using the
		## target() template (as seen in character) is needed to be added !!
		for enemy in enemy_in_range:
			warrior_swing(enemy)
		reset_cooldown()
	if !($RangeDetection.has_overlapping_bodies()):
		animation_controller.play("idle")

func _physics_process(delta: float) -> void:
	super(delta)

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)
	if swing_ready:
		warrior_swing(body)
		show_hurt_box()
		reset_cooldown()
	
func _on_timer_timeout():
	swing_ready = true
	print(name, "'s ATTACK READY")
	
#dealing warrior sword swing damage to enemies
func warrior_swing(enemy: Enemy) -> void:
	print(name, " attacked ", enemy.name)
	var dir = get_direction_to_enemy(enemy)
	var cardinal = get_cardinal_direction(dir)
	change_attack_direction(cardinal)
	## !! see comments in Character.gd !!
	enemy.take_damage(1)
	print(enemy.name + " health: ", enemy.get_health())

#reset timer and swing ready
func reset_cooldown() -> void:
	warrior_timer.start()
	swing_ready = false
	print(name + "'s attack on cooldown")

#show hurt box for 1 second when the warrior swings
func show_hurt_box() -> void:
	warrior_hurt_box.show()
	print(name + "'s hurt box shown")
	## this line will wait 3 sec before proceeding to the next
	await get_tree().create_timer(0.5).timeout
	warrior_hurt_box.hide()
	print(name + "'s hurt box hidden")
	
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
			
func get_first_enemy() -> Enemy:
	var first = null
	#30 taken from movement function
	var edge = 30
	var placeholder = 0
	
	for body in $RangeDetection.get_overlapping_bodies():
		var pos = global_position
		if pos < edge && pos > placeholder:
			placeholder = pos
			first = body
	
	return first
	
func get_last_enemy() -> Enemy:
	var last = null
	var edge = -30
	var placeholder = 0
	
	for body in $RangeDetection.get_overlapping_bodies():
		var pos = global_position
		if pos > edge && pos < placeholder:
			placeholder = pos
			last = body
	
	return last
	
func get_direction_to_enemy(enemy: Node3D) -> Vector3:
	return (enemy.global_transform.origin - global_transform.origin).normalized()
	
enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}

func get_cardinal_direction(dir: Vector3) -> int:
	#if the absolute value of x is greater than z then its east to west
	if abs(dir.x) > abs(dir.z):
		if dir.x > 0:
			return Direction.EAST
		else:
			return Direction.WEST
	else:
		if dir.z > 0:
			return Direction.SOUTH
		else:
			return Direction.NORTH
			
func change_attack_direction(direction: int):
	match direction:
		Direction.NORTH:
			warrior_hurt_box.rotation.y = deg_to_rad(180)
			animation_controller.play("swing_north")
			animation_controller.play("swing")
		Direction.SOUTH:
			warrior_hurt_box.rotation.y = deg_to_rad(0)
			animation_controller.play("swing_south")
			animation_controller.play("swing")
		Direction.EAST:
			warrior_hurt_box.rotation.y = deg_to_rad(90)
			animation_controller.play("swing_east")
			animation_controller.play("swing")
		Direction.WEST:
			warrior_hurt_box.rotation.y = deg_to_rad(-90)
			animation_controller.play("swing_west")
			animation_controller.play("swing")
