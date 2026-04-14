extends Character
class_name Enemy

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	super(delta)
	movement()

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)
	
#Moves the enemy
#Uses randf range to create 'organic' movement on the z axis, needs more smoothing
func movement ():
	var variation = randf_range(.5, -.5)
	#self.position.z += lerp(variation, variation, .1)
	##moves the enemy along the x axis across the screen
	if self.position.x < 30: 
		self.position.x += 0.1
	elif self.position.x >= 30: 
		self.position.x = -30
		##puts them on the left edge of the map, 
		##off screen so they can go back to the right. 

#If towers in radius, take damage. 
#the index needs to be changed so player can toggle first, last, etc. 
#This is really just to get the bugs to stop. Needs replaced so they attack others, not just themselves. 
func attacked(): 
	if (tracking_array[0] != null): 
		self.take_damage(1)
	
# Damages the player towers when the enemy reaches the end
func attackingTowers() -> void:
	var scene = get_tree().current_scene
	if scene == null:
		return

	var tower_1 = scene.get_node_or_null("Tower")
	var tower_2 = scene.get_node_or_null("Tower2")

	if tower_1 != null:
		tower_1.take_damage(2)

	if tower_2 != null:
		tower_2.take_damage(2)
