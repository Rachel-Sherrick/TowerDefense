extends PathFollow3D

@export var speed := 2.8

func _ready():
	progress = 0
	
func _physics_process(delta):
	progress += speed * delta
