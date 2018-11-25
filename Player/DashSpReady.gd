extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (int) var rot_speed = 20

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process(true)

func _process(delta):
	rotate(rot_speed * delta)

