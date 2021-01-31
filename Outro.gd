extends Node2D

var numero_pagine = 4
var i_pag = 0
var fx_eli = preload("res://asset/audio/fx/helicopter_nhu0506808.ogg")
var changing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$fx.stream=fx_eli
	$fx.play()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_down") and changing == false:
		changing = true
		i_pag+=1
#		if i_pag == 1:
#			$fx.play()
#			yield($fx, "finished")
#			$fx.play()
		if i_pag == numero_pagine-1:
			$CanvasLayer/Label.hide()
			$CanvasLayer/AnimatedSprite.hide()
		if numero_pagine == i_pag:
			$fx.stop()
			get_tree().change_scene("res://Credits.tscn")
		else:
			$Tween.interpolate_property($imgs, "position", $imgs.position, Vector2($imgs.position.x, $imgs.position.y - 600), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")
			changing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
