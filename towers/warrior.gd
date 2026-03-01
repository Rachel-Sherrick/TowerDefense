extends Tower
class_name Warrior

@onready var warrior_hurt_box: Area3D = $warrior_hurt_box
@onready var hurt_box_mesh: MeshInstance3D = $warrior_hurt_box/hurt_box_mesh
@onready var warrior_timer: Timer = $WarriorTimer

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
