extends Node2D


# Declare member variables here. Examples:
# var a = 2
export (PackedScene) var Condor

onready var bg_chase = preload("res://asset/audio/bg/desert_chase.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$player/Camera2D.enabled = true
	$VacTimer.start()
	$Timer.start()
	$Timer2.start()
	for t in get_tree().get_nodes_in_group('tempesta'):
		t.set_deferred('emitting', false)
	$GUI/TextureProgress_vax.max_value = $VacTimer.wait_time
	$GUI/TextureProgress.max_value = $player.energy_max



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $GUI/VacLabel.text != str($VacTimer.time_left):
		$GUI/VacLabel.text = str($VacTimer.time_left)
		$GUI/TextureProgress_vax.value = $VacTimer.time_left
	$GUI/TextureProgress.value = $player.energy
	
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
	



func _on_Timer2_timeout():
	$CondorPath2/CondorSpawnLocation.offset = randi()
	var condor = Condor.instance()
	add_child(condor)
	var direction = $CondorPath2/CondorSpawnLocation.rotation + PI / 2
	condor.position = $CondorPath2/CondorSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	#condor.rotation = direction
	condor.linear_velocity = Vector2(rand_range(condor.min_speed, condor.max_speed), 150)
	var corrente = rand_range(-1, 1)
	if corrente < 0 : 
		condor.linear_velocity.x *= -1
	#condor.linear_velocity = condor.linear_velocity.rotated(direction)
	#if condor.linear_velocity.x > 0:
	condor.get_node("AnimatedSprite").flip_h = condor.linear_velocity.x > 0


func _on_player_start_chase():
	$ContrattazioneBanditi/Node2DBanditi/cammello/CollisionShape2D.set_deferred('disabled', false)
	$ContrattazioneBanditi/Node2DBanditi/cammello/AnimatedSprite.flip_h = true
	$ContrattazioneBanditi/Node2DBanditi/cammello.move()
	$ContrattazioneBanditi/Node2DBanditi/cammello/AnimatedSprite.play('walk')
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = bg_chase
	$AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_player_end_game():
	$VacTimer.stop()
	$afx_elicopter.play()
	yield($afx_elicopter, 'finished')
	get_tree().change_scene("res://Outro.tscn")
	pass # Replace with function body.


func _on_VacTimer_timeout():
	$player.energy = 0
	$background/suolo/fondale.queue_free()
	pass # Replace with function body.


func _on_player_fumosalto():
	var fs = preload("res://fumo_salto.tscn")
	var instance = fs.instance()
	instance.frame = 0
	instance.position = $player.position
	instance.position.y -= 70
	instance.position.x -= 60
	add_child(instance)
	#instance.play('default')
	yield(instance, "animation_finished")
	instance.queue_free()
	#print('elimino fumosalto instance!')
	pass # Replace with function body.
