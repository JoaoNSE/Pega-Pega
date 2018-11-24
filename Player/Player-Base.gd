extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#Variaveis da visao
export (bool) var draw_line = false;
var laser_color = Color(1.0, .329, .298)

var target
var targets = []
var hit_pos

#Variáveis da movimentação
const BASE_SPD = 5
#velocidade atual
var p_speed
var velocity = Vector2()


func _ready():
	p_speed = BASE_SPD
	_child_ready()

#ready para ser implementado nos filhos
func _child_ready():
	pass

func aim():
	var show_enemy = false
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	for t in targets:
		show_enemy = false
		var ignore = targets.duplicate()
		ignore.append(self)
		ignore.remove(ignore.find(t))
		
		var target_extents = t.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
		var nw = t.position - target_extents
		var se = t.position + target_extents
		var ne = t.position + Vector2(target_extents.x, -target_extents.y)
		var sw = t.position + Vector2(-target_extents.x, target_extents.y)
		
		for pos in [t.position, nw, ne, se, sw]:
			var result = space_state.intersect_ray(position,
					pos, ignore, collision_mask)
			if result:
				hit_pos.append(result.position)
				if result.collider.name == t.name:
					show_enemy = show_enemy or true;
					
				else:
					show_enemy = show_enemy or false;
					
		if show_enemy:
			t.setShow()
			
		else:
			t.setHide()

func control(delta):
		
	var speed_fx = 1000 * p_speed
		
	velocity = Vector2(0, 0)
	
	if (Input.is_action_pressed("ui_up")):
		velocity = Vector2(velocity.x, -speed_fx)
		
	if (Input.is_action_pressed("ui_down")):
		velocity = Vector2(velocity.x, speed_fx)
	
	if (Input.is_action_pressed("ui_left")):
		velocity = Vector2(-speed_fx, velocity.y)
		
	if (Input.is_action_pressed("ui_right")):
		velocity = Vector2(speed_fx, velocity.y)
		
	velocity.normalized()
	velocity *= delta
	
	
func _physics_process(delta):
	control(delta)
	move_and_slide(velocity)
	if draw_line:
		update()
	if !targets.empty():
		aim()
	
	
func _draw():
	_child_draw()
	if target:
		for hit in hit_pos:
			draw_circle((hit - position)*2, 5, laser_color)
			draw_line(Vector2(), (hit - position)*2, laser_color)
		hit_pos = []
		
func _child_draw():
	pass
	
#algum corpo entrou no campo de visão
func _on_Visibility_body_entered(body):
	if targets.has(body):
		return
	if body.is_in_group("Hideable"):
		target = body
		targets.append(body)

#algum corpo saiu do campo de visão
func _on_Visibility_body_exited(body):
	if targets.has(body):
		body.setHide()
		targets.remove(targets.find(body))
	