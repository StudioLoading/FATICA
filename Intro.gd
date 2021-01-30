extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var numero_pagine = 4
var i_pag = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		i_pag+=1
		if i_pag == 1:
			$fx.play()
			yield($fx, "finished")
			$fx.play()
		if numero_pagine == i_pag:
			$bg.stop()
			$CanvasLayer/Label.text = "WAIT..."
			get_tree().change_scene("res://main.tscn")
		else:
			$Tween.interpolate_property($imgs, "position", $imgs.position, Vector2($imgs.position.x, $imgs.position.y - 600), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
