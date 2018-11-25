extends "Player-Base.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#variáveis do dash
var can_dash = true
var dashing = false
var dash_spd = 10
var dash_timer
var dash_cd_timer


func _child_ready():
	dash_timer = get_node("DashTimer")
	dash_cd_timer = get_node("DashCooldown")
	ignore_rc.append(get_node("ColisionDetect"))
	set_process(true)
	
func _process(delta):
	if(Input.is_action_just_pressed("Dash")):
		dash()

#funções do dash
func dash():
	if !can_dash:
		return
	$DashTrail.emitting = true
	$DashSpReady.hide()
	p_speed = dash_spd
	dashing = true
	can_dash = false
	dash_timer.start()

func _on_DashTimer_timeout():
	p_speed = BASE_SPD
	dashing = false
	$DashTrail.emitting = false
	dash_cd_timer.start()
	
func _on_DashCooldown_timeout():
	$DashSpReady.show()
	can_dash = true

func pegar(body):
	body.queue_free()

func _on_ColisionDetect_body_entered(body):
	print("colidiu com" + body.name)
	if (body.is_in_group("Bixo")):
		pegar(body)
