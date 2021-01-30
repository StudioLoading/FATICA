extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	var bubble = get_node("../../../player")
	bubble.connect("bubble", self, "aa")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func aa():
	get_node("Sprite").visible = true
	$Timer.start()




func _on_Timer_timeout():
	get_node("Sprite").visible = false
