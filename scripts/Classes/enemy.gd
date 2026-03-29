extends Character
class_name Enemy

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	super(delta)

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
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
	
