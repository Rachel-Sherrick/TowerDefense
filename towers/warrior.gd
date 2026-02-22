extends Tower
class_name Warrior

@onready var hurt_box_mesh: MeshInstance3D = $HurtBox/HurtBoxMesh
@onready var hurt_box: Area3D = $HurtBox

#warrior swing cooldown in seconds
var swing_cooldown : float = 3.0
#is the cooldown over
var swing_ready : bool = false

func _ready() -> void:
	#on load the hurt box is not visible. the mesh instance is just a visible 
	#confirmation the swing happens without an animation.
	hurt_box.hide()

func _process(delta: float) -> void:
	## !! Replace time elapsed with a Timer node that is read by this script.
	## it will serve the same function and much easier to debug since it
	## is signal based !!
	time_elapsed += delta
	print(time_elapsed)
	#if cooldown is over hurt box is visible again and attack is ready
	## !! use swing_cooldown variable instead !!
	if time_elapsed >= 3.0:
		print(name, "'s attack ready")
		swing_ready = true
		#hurt_box.show()
		## replace this code
		time_elapsed = 0.0
	#if the swing is ready and there's collision objects in hurt box
	## !! Append this if statement to the one above, no need to revaluate
	## swing_ready !!
	if swing_ready == true && hurt_box.has_overlapping_bodies():
		var enemy_in_range = hurt_box.get_overlapping_bodies()
		## !! Edited to make sure all enemies in range were hit
		## also add call to target a specific enemy using the
		## target() template (as seen in character) is needed to be added !!
		for enemy in enemy_in_range:
			warrior_swing(enemy)
		## !! time_elapsed passed will always be 0 when passed here !!
		show_hurt_box(time_elapsed)
		reset_cooldown()

func _physics_process(delta: float) -> void:
	super(delta)

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)
	if swing_ready:
		warrior_swing(body)
		## !! add call to show hurt box here !!
		## !! add call to reset cooldown !!
	
#dealing warrior sword swing damage to enemies
func warrior_swing(enemy) -> void:
	print(name, " attacked ", enemy.name)
	## !! see comments in Character.gd !!
	enemy.set_health(1)
	print(enemy.name + " health: ", enemy.get_health())

#reset timer and swing ready and make hurt box invisible on cooldown
func reset_cooldown() -> void:
	time_elapsed = 0.0
	swing_ready = false
	#hurt box invisible on cooldown
	## !! redundant call to hide hurtbox !!
	#hurt_box.hide()
	print(name + "'s attack on cooldown")

#show hurt box for 1 second when the warrior swings as stand in for animation
#this function stops the infinite prints for some reason.
func show_hurt_box(current_time: float) -> void:
	var box_time = current_time
	## !! Replaced with await get_tree().create_timer(1.0).timeout !!
	#while (current_time - box_time) < 1.0:
	hurt_box.show()
	print(name + "'s hurt box shown")
	## this line will wait 3 sec before proceeding to the next
	## as there is no need to repeatedly call hurt_box.show()
	await get_tree().create_timer(1).timeout
	hurt_box.hide()
	print(name + "'s hurt box hidden")
