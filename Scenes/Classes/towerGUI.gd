extends Control
##
@onready var target: Node3D = $".."
@onready var offset_3d: Vector3 = Vector3(0,5,0)

func _ready() -> void:
	if get_parent() is Orb:
		hide()
		$OptionButton.hide()

func _process(_delta):
	var pos_3d = target.global_position + offset_3d
	var cam = get_viewport().get_camera_3d()
	var pos_2d = cam.unproject_position(pos_3d)
	global_position = pos_2d
	visible = not cam.is_position_behind(pos_3d)
