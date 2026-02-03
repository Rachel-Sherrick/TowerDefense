extends RayCast3D

#pulls the character3D to access the groups
@onready var characterBody= $".."
#pulls range to filter out characters outside the range
@onready var range : Area3D =  $"../Range"

var target : Character = null
var attack = false
func _physics_process(delta) -> void:
	if is_colliding(): 
			#Am I hitting a character or the landscape
			if get_collider() is Character: 
				#what am I hitting
				target = get_collider()
				#Am I hitting a friend or an enemy?
				if target.get_groups() == characterBody.get_groups(): 
					print ("Friend!")
					attack = false
				else: 
					print ("Enemy!")
					attack = true
					
