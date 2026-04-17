extends Tower
class_name Wizard

#maybe this can be used for targeting? idk
var aim_list = []
var bullet_scene = preload("res://bullet.tscn")

#tests if enemies are within the range detection
var in_range: bool = false

#tests if the timer has timed out for firing in intervals
var fire_ready: bool = false
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()

func _physics_process(delta: float) -> void:
	super(delta)
	if in_range == true && fire_ready == true:
		#Uncommenting this function call will cause a problem
		#that needs to be debugged
		fire_projectile(aim_list[0])
		

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)
	print("Enemy exited ", name, "'s range")
	aim_list.erase(body)
	in_range = false

func _on_range_body_entered(body: Node3D) -> void:
	super(body)
	print("Enemy entered ", name, "'s range")
	aim_list.append(body)
	in_range = true
	
	
func fire_projectile(target) -> void:
	print("WIZARD FIRING ATTACK")
	var projectile = bullet_scene.instantiate()
	projectile.position = Vector3(position.x, 1.0, position.z)
	projectile.target = target.position
	add_child(projectile)
	fire_ready = false

func _on_timer_timeout() -> void:
	fire_ready = true
	print("Wizard ready to fire")
