extends AudioStreamPlayer

@onready var shop = ResourceLoader.load("res://songs/shopsong.wav")
@onready var main = ResourceLoader.load("res://songs/sneswip1.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_stream(main)
	#play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
