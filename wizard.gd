extends Tower
class_name Wizard

#maybe this can be used for targeting? idk

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
	if fire_ready == true:
		#Uncommenting this function call will cause a problem
		#that needs to be debugged
		fire_projectile()
		

func _on_range_detection_body_exited(body: Node3D) -> void:
	super(body)

func _on_range_body_entered(body: Node3D) -> void:
	super(body)


func fire_projectile() -> void:
	if currentTarget != null: 
		print("WIZARD FIRING ATTACK")
		var projectile = bullet_scene.instantiate()
		projectile.position = Vector3(position.x, 1.0, position.z)
		projectile.target = currentTarget.position
		print(currentTarget.position)
		add_child(projectile)
		fire_ready = false

func _on_timer_timeout() -> void:
	fire_ready = true
	print("Wizard ready to fire")
