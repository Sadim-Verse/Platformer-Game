extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group('player')
@export var run_speed := 10
@export var gravity := 300
@export var health := 100

var x_direction := 1
var speed = Global.enemy_parameters['soldier']['speed']
var speed_modifier := 1
var attacking = false
var attack_cooldown = false
var can_take_damage = false
var player_is_idle = false

func _process(delta):
	#velocity.x = x_direction * speed * speed_modifier
	movement(delta)
	check_cliff()
	animate()
	check_player_distance()
	receiving_damage()
	death()
	
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
		Global.enemy_attacking = true
		player.is_hurt = true
		$AnimationPlayer.current_animation = 'Attack'
		print("Attack")
		$Timers/Cooldown_timer.start()
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
	$Timers/Attack_restarter.start()
	player_is_idle = true
	can_take_damage = true
	player.is_hurt = false
	Global.enemy_attacking = false
	$AnimationPlayer.current_animation = 'Idle'
	
func attack_restarter_timeout():
	print("chek chek")
	player_is_idle = false
	attack_cooldown = false
	can_take_damage == false

func _on_cooldown_timer_timeout():
	cooldown_timer_timeout()

func _on_attack_restarter_timeout():
	attack_restarter_timeout()

func receiving_damage():
	if Global.player_attacking == true && player_is_idle == true:
		if can_take_damage == true:
			health -= 20
			$AnimationPlayer.current_animation = 'Hurt'
			$Timers/take_damage_cooldown.start()
			can_take_damage = false
			print("Orc health: ", health)

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func death():
	if health < 0:
		health = 0
		$AnimationPlayer.current_animation = 'Death'
		$Timers/Death.start()

func _on_death_timeout():
	print("Gone")
	self.queue_free()
