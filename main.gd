extends Node2D


# Declare member variables here. Examples:
# var a = 2
export (PackedScene) var Condor


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$player/Camera2D.enabled = true
	$VacTimer.start()
	$Timer.start()
	for t in get_tree().get_nodes_in_group('tempesta'):
		t.set_deferred('emitting', false)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $GUI/VacLabel.text != str($VacTimer.time_left):
		$GUI/VacLabel.text = str($VacTimer.time_left)



func _on_Timer_timeout():
	$CondorPath/CondorSpawnLocation.offset = randi()
	var condor = Condor.instance()
	add_child(condor)
	var direction = $CondorPath/CondorSpawnLocation.rotation + PI / 2
	condor.position = $CondorPath/CondorSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	#condor.rotation = direction
	condor.linear_velocity = Vector2(rand_range(condor.min_speed, condor.max_speed), 150)
	var corrente = rand_range(-1, 1)
	if corrente < 0 : 
		condor.linear_velocity.x *= -1
	#condor.linear_velocity = condor.linear_velocity.rotated(direction)
	#if condor.linear_velocity.x > 0:
	condor.get_node("AnimatedSprite").flip_h = condor.linear_velocity.x > 0
	

