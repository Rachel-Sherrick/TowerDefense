extends Character
class_name Tower

## @onready var ray_cast_3d: RayCast3D = $RayCast3D
## var enemy : Character = null
var time_elapsed : float = 0.0
#warrior swing cooldown in seconds
var swing_cooldown : float = 3.0
#is the cooldown over
var swing_ready : bool = false

#show/hide mesh
@onready var hurt_box: Area3D = $HurtBox

func _ready() -> void:
	#on load the hurt box is not visible. the nesh instance is just a visible 
	#confirmation the swing happens without an animation.
	hurt_box.visible = false

func _process(delta: float) -> void:
	time_elapsed += delta
	#print(time_elapsed)
	#if cooldown is over hurt box is visible again and attack is ready
	if time_elapsed >= 3.0:
		print("attack ready")
		swing_ready = true
		hurt_box.visible = true
		time_elapsed = 0.0
	#if the swing is ready and there's collision objects in hurt box
	if swing_ready == true && hurt_box.has_overlapping_bodies():
		var enemy_body = hurt_box.get_overlapping_bodies()
		warrior_swing(enemy_body)
		reset_cooldown()
		#show_hurt_box(time_elapsed)
		

func _physics_process(delta: float) -> void:
	super(delta)

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	#super(body)
	if swing_ready == true:
		warrior_swing(body)
	
#dealing warrior sword swing damage to enemies
func warrior_swing(enemy) -> void:
	print("attacked ", enemy)
	#getter/setter for health
	#enemy.health -= 1
	#print("enemy health: ", enemy.health)

#reset timer and swing ready and make hurt box invisible on cooldown
func reset_cooldown() -> void:
	time_elapsed = 0.0
	swing_ready = false
	#hurt box invisible on cooldown
	hurt_box.visible = false
	print("attack on cooldown")

#show hurt box for 1 second when the warrior swings as stand in for animation
#this function stops the infinite prints for some reason.
func show_hurt_box(current_time: float) -> void:
	var box_time = current_time
	while (current_time - box_time) < 1.0:
		hurt_box.visible = true
	hurt_box.visible = false

#func deal_damage(enemy):
#	if time_elapsed >= 1.0:
#		enemy.health -= 1
#		print("Enemy health ", enemy.health)
#		time_elapsed = 0.0
