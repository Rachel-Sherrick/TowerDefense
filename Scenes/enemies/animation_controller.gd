extends Node3D

@onready var sprite_body = $SpriteBody

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_body.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_range_detection_body_entered(body):
	sprite_body.play("attack")


func _on_range_detection_body_exited(body):
	sprite_body.play("walk")
