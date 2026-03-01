extends Character
class_name Tower

## @onready var ray_cast_3d: RayCast3D = $RayCast3D
## var enemy : Character = null
var time_elapsed : float = 1.0

func _process(delta: float) -> void:
	time_elapsed += delta
	
	if time_elapsed >= 1.0:
		var enemy = tracking_array [0]
		deal_damage(enemy) ##h.s edited to see if health will work properly

func _physics_process(delta: float) -> void:
	super(delta)

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)

func deal_damage(enemy):
	if time_elapsed >= 1.0:
		#Checks to see if the array is filled. This probably the worst way to do this 
		#but idk anymore. If array is filled take damage. 
		if (enemy != null): 
			self.take_damage(1)
			time_elapsed = 0.0
