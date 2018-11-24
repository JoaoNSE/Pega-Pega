extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process(true)

func _process(delta):
	update()
	
func _draw():
	draw_line(Vector2(0, 0), get_parent().get_node("Player").position - position, Color(1.0, 0.0, 0.0, 1.0))
