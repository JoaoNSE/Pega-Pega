extends "Player-Base.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var cor = Color(250.0, 255.0, 60.0, 255.0)

var mira_normal = "res://Player/mira.png"
var mira_vermelha = "res://Player/mmira_vermelha.png"

#variáveis do dash
var can_aim = true
var can_dash = true
var dashing = false
var dash_spd = 10
var dash_timer
var dash_cd_timer

var teleport_direction = Vector2(1, 0)
var teleport_distance = 100


func _child_ready():
	#$Sprite.modulate = cor
	dash_timer = get_node("DashTimer")
	dash_cd_timer = get_node("DashCooldown")
	
	ignore_rc.append(get_node("ColisionDetect"))
	ignore_rc.append(get_node("Mira"))
	set_process(true)
	
func _process(delta):
	if (!dashing) and (last_direction != teleport_direction) and (last_direction!=Vector2(0, 0)):
		teleport_direction = last_direction
		
	if(Input.is_action_pressed("Dash")):
		mostra_mira()
	if(Input.is_action_just_released("Dash")):
		solta_mira()

func _child_physics(delta):
	pass
	#if dashing:
		#move_and_slide(velocity)
	#	move_and_slide(teleport_direction*teleport_distance*1000*delta)

func mostra_mira():
	if !can_aim or teleport_direction == Vector2(0, 0):
		return
	can_move = false
	$Mira.position = teleport_direction*teleport_distance
	$Mira.show()

func solta_mira():
	$Mira.hide()
	if !can_dash or teleport_direction == Vector2(0, 0):
		can_move = true
		return
	
	can_aim = false
	dash()

#funções do dash
func dash():
	if !can_dash or teleport_direction == Vector2(0, 0):
		return
	$DashTrail.emitting = true
	
	can_move = false
	
	$DashSpReady.hide()
	$CollisionShape2D.disabled = true
	$Sprite.modulate.a = .5
	can_dash = false
	dash_timer.start()
	position += teleport_direction*teleport_distance	

func _on_DashTimer_timeout():
	can_move = true
	$Sprite.modulate.a = 1.0
	dashing = false
	$CollisionShape2D.disabled = false
	$DashTrail.emitting = false
	dash_cd_timer.start()
	
func _on_DashCooldown_timeout():
	$DashSpReady.show()
	can_dash = true
	can_aim = true

func pegar(body):
	body.queue_free()

func _on_ColisionDetect_body_entered(body):
	print("colidiu com" + body.name)
	if (body.is_in_group("Bixo")):
		pegar(body)
		
func _child_draw():
	draw_line(Vector2(), (last_direction)*100, Color(.2, .7, .2, 1.0))

func _on_Mira_body_entered(body):
	get_node("Mira/Mira").texture = load(mira_vermelha)
	can_dash = false


func _on_Mira_body_exited(body):
	get_node("Mira/Mira").texture = load(mira_normal)
	can_dash = true
