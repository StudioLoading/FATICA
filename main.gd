extends Node2D


# Declare member variables here. Examples:
# var a = 2



# Called when the node enters the scene tree for the first time.
func _ready():
	$player/Camera2D.enabled = true
	$VacTimer.start()
	for t in get_tree().get_nodes_in_group('tempesta'):
		t.set_deferred('emitting', false)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GUI/VacLabel.text = str($VacTimer.time_left)
	
	
