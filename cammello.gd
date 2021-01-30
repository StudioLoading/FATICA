extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moving = false
export (int) var gravity = 1200
export (Vector2) var velocity = Vector2.ZERO


func _ready():
	var bubble = get_node("../../../player")
	bubble.connect("bubble", self, "aa")
	velocity.x = 300
	pass # Replace with function body.



func _process(delta):
	if moving:
		velocity.y += gravity * delta
		#move_and_collide(Vector2(10, 3))
		velocity = move_and_slide(velocity, Vector2(0, -1))


func aa():
	get_node("Sprite").visible = true
	$Timer.start()

func move():
	moving = true


func _on_Timer_timeout():
	get_node("Sprite").visible = false
