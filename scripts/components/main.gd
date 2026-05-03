extends Node

#@onready var health: Health = $Health
#var wave = 1
#var round = 1
#@onready var wave_label: Label = $Player/GUI/WaveLabel
#@onready var round_label: Label = $Player/GUI/RoundLabel
#@onready var start_round_button: Button = $Player/GUI/StartRoundButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Battleground/Orb.orb_destroyed.connect(_on_player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if health.ants_killed >= 10 and !$Battleground/Orb.orb_destroyed:
		#if wave < 5:
			#wave += 1
			#wave_label.text = ("Wave: " + str(wave))
		#else: 
			#wave = 1
			#round += 1
			#round_label.text = ("Round: " + str(round))
			#start_round_button.show()
	
###H.S NEEDS THIS TO STAY HERE
func _on_player_died() -> void:
	for child in $Battleground/Characters.get_children():
		child.queue_free()
	
	get_tree().change_scene_to_file("res://EndOfGameLOSE.tscn")
