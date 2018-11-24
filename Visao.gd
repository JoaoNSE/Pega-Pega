extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var h_object = null

var result_pos

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#set_process(true)
	pass
	
func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if h_object:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(position, h_object.position, [self, get_parent()], collision_mask)
		if result:
			get_parent().enemy_pos = result.position
			get_parent().update()
	#		if result.collider.name == h_object.name:
	#			h_object.setShow()



func _on_Visao_body_entered(body):
	if(body.is_in_group("Hideable")):
		h_object = body
		body.setShow()
		#get_parent().get_node("Line2D").add_point(position)
		#get_parent().get_node("Line2D").add_point((position + h_object.position)*2)
		
		
func _on_Visao_body_exited(body):
	if h_object == null:
		return
	if(body.is_in_group("Hideable")):
		body.setHide()
		h_object = null
		#get_parent().get_node("Line2D").remove_point(0)
		#get_parent().get_node("Line2D").remove_point(1)
		get_parent().enemy_pos = null
		get_parent().update()
