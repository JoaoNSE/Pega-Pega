extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var runner = "res://Player/Runner.tscn"
var teleporter = "res://Player/Teleporter.tscn"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process(true)

func _process(delta):
	if(Input.is_action_just_pressed("Num1")):
		get_parent().get_node("Meio/Player").queue_free()
		var pley = load(runner).instance()
		pley.name = "Player"
		get_parent().get_node("Meio").add_child(pley)
	if(Input.is_action_just_pressed("Num2")):
		get_parent().get_node("Meio/Player").queue_free()
		var pley = load(teleporter).instance()
		get_parent().get_node("Meio").add_child(pley)
		pley.name = "Player"
