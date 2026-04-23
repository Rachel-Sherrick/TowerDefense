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
	timer.wait_time = attack_interval
	timer.start()

func _process(delta: float) -> void:
	if fire_ready == true && $RangeDetection.has_overlapping_bodies():
		#await attack_handler()
		fire_projectile(target())
	if !($RangeDetection.has_overlapping_bodies()):
		#animation_controller.play("idle")
		pass
		
		

func _physics_process(delta: float) -> void:
	super(delta)
	#if in_range == true && fire_ready == true:
		##Uncommenting this function call will cause a problem
		##that needs to be debugged
		#fire_projectile(aim_list[0])
		#

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)
	print("Enemy exited ", name, "'s range")
	in_range = false

func _on_range_body_entered(body: Node3D) -> void:
	super(body)
	print("Enemy entered ", name, "'s range")
	in_range = true
	
	
func fire_projectile(target: Enemy) -> void:
	print("WIZARD FIRING ATTACK")
	var projectile: Bullet = bullet_scene.instantiate()
	var target_glob_pos = Vector3(-1, 0, 0)
	
	## these prevent the bullet from flying off at odd angles or colliding into
	## the ground
	projectile.position = Vector3(projectile.position.x - 2, projectile.position.y + 1, projectile.position.z)
	
	##checks if object has been deleted before grabbing its position
	if target != null:
		target_glob_pos = Vector3(target.global_position.x, projectile.position.y, target.global_position.z)
		
	projectile.target = target_glob_pos
	projectile.attack_damage = attack_damage
	add_child(projectile)
	fire_ready = false

func _on_timer_timeout() -> void:
	fire_ready = true
	print("Wizard ready to fire")
