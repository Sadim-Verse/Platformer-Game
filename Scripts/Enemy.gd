extends CharacterBody2D

var x_direction := 1
var speed = Global.enemy_parameters['soldier']['speed']
@export var run_speed := 10
@export var gravity := 300
var speed_modifier := 1
var attacking = false
var attack_cooldown = false
@onready var player = get_tree().get_first_node_in_group('player')

func _process(delta):
	#velocity.x = x_direction * speed * speed_modifier
	movement(delta)
	check_cliff()
	animate()
	check_player_distance()
	
	move_and_slide()

func animate():
	$Sprite2D.flip_h = x_direction < 0
	if attacking == true:
		var difference = (player.position - position).normalized()
		$Sprite2D.flip_h = difference.x < 0
		if position.distance_to(player.position) < 50: 
			attack_and_cooldown()
		return	
	$AnimationPlayer.current_animation = 'Walk' if x_direction else 'Idle'

func attack_and_cooldown():
	if attack_cooldown == false:
		$AnimationPlayer.current_animation = 'Attack'
		print("Attack")
		$Cooldown_timer.start(3)
		attack_cooldown = true
		speed_modifier = 0

func check_player_distance():
	if position.distance_to(player.position) < 250:
		attacking = true
		speed_modifier = 0
	else:
		attacking = false
		speed_modifier = 1

func movement(delta):
	velocity.x = x_direction * speed * speed_modifier
	if is_on_floor() == false:
		velocity.y  += gravity * delta
		if velocity.y > 1000: velocity.y = 500
	if attacking:
		position += (player.position - position)/run_speed
		#return

func _on_wall_check_area_body_entered(body):
	x_direction *= -1
	
func  check_cliff():
	if x_direction > 0 && !($FloorRays/Right.get_collider()):
		x_direction = -1
	if x_direction < 0 && !($FloorRays/Left.get_collider()):
		x_direction = 1

func cooldown_timer_timeout():
	print("Idle")
	$Attack_restarter.start(3)
	$AnimationPlayer.current_animation = 'Idle'
	
func attack_restarter_timeout():
	print("chek chek")
	attack_cooldown = false

func _on_cooldown_timer_timeout():
	cooldown_timer_timeout()

func _on_attack_restarter_timeout():
	attack_restarter_timeout()
