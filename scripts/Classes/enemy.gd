extends Character
class_name Enemy

var goal_position: Vector3
var target_tower: Node3D = null
var state := "marching"

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
<<<<<<< Updated upstream
	super(delta)
=======
	movement(delta)

func set_goal(pos: Vector3) -> void:
	goal_position = pos
>>>>>>> Stashed changes

func _on_range_detection_body_exited(body: Node3D) -> void:
	if body == target_tower:
		target_tower = null
		state = "marching"

func _on_range_body_entered(body: Node3D) -> void:
<<<<<<< Updated upstream
	super(body)
	
#Moves the enemy
#Uses randf range to create 'organic' movement on the z axis, needs more smoothing
func movement ():
	var variation = randf_range(.5, -.5)
	self.position.z += lerp(variation, variation, .1)
	##moves the enemy along the x axis across the screen
	if self.position.x < 30: 
		self.position.x += 0.1
	elif self.position.x >= 30: 
		self.position.x = -30
		##puts them on the left edge of the map, 
		##off screen so they can go back to the right. 

#Attacks towers within radius
func attackingTowers(): 
	pass
=======
	if body.is_in_group("towers"):
		target_tower = body
		state = "attacking"
>>>>>>> Stashed changes
	
#Moves the enemy towards goal or a tower
func movement (delta: float) -> void:
	var target_pos := goal_position
	if state == "attacking" and is_instance_valid(target_tower):
		target_pos = target_tower.global_position
	var dir := target_pos - global_position
	dir.y = 0
	if dir.length() > 0.1:
		dir = dir.normalized()
		global_position += dir * speed * delta
