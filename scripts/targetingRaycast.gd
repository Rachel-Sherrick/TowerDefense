extends RayCast3D
signal detect_friend(body : CollisionObject3D)
signal detect_foe(body : CollisionObject3D)
#pulls the character3D to access the groups

@onready var characterBody= $".."
#pulls range to filter out characters outside the range
@onready var range_detection : Area3D =  $"../RangeDetection"
var target : Character = null
func _ready() -> void:
	set_physics_process(false)
	hide()

func _physics_process(delta) -> void:
	if is_colliding(): 
			#Am I hitting a character or the landscape
			if get_collider() is Character: 
				#what am I hitting
				target = get_collider()
				#Am I hitting a friend or an enemy?
				if target.get_groups() == characterBody.get_groups(): 
					print ("Friend!")
					emit_signal("detect_friend", target)
				else: 
					print ("Enemy!")
					emit_signal("detect_foe", target)
	else:
		set_physics_process(false)
		hide()
