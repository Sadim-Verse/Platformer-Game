extends CharacterBody2D
class_name Player
const max_jumps = 2


@export var lives = 3
var health = 100
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var attack_inProgress = false

@export var gravity = 600
@export var jump_force = 250
@export var jumps_left = max_jumps
var launched = true
@export var speed = 150
var active = true


@onready var animated_sprite = $player


func _physics_process(delta):
	
	basic_movement(delta)
	player_animations()
	enemy_attack()
	player_died()
	attack()
	
	move_and_slide()
	
func basic_movement(delta):
	if is_on_floor() == false:
		velocity.y  += gravity * delta
		if velocity.y > 1000: velocity.y = 500
		
	var direction = 0
		
	if active == true:
		jump_logic()
		
		direction = Input.get_axis("move_left", "move_right")
	
	
	velocity.x = direction * speed
	
func player_animations():
	#if active == true:
	if Input.is_action_pressed("move_left") && is_on_floor():
		animated_sprite.play("run")
		animated_sprite.set_flip_h(true)
	
	elif Input.is_action_pressed("move_right") && is_on_floor():
		animated_sprite.play("run")
		animated_sprite.set_flip_h(false)
	
	elif Input.is_action_just_pressed("jump") || velocity.y < 0:
		animated_sprite.play("jump")
		if Input.is_action_pressed("move_left"):
			animated_sprite.set_flip_h(true)
		elif Input.is_action_pressed("move_right"):
			animated_sprite.set_flip_h(false)
	
	elif not is_on_floor() && velocity.y > 0:
		animated_sprite.play("fall") 
		if Input.is_action_pressed("move_left"):
			animated_sprite.set_flip_h(true)
		elif Input.is_action_pressed("move_right"):
			animated_sprite.set_flip_h(false)
	
	elif Input.is_action_pressed("block") && is_on_floor():
		animated_sprite.play("block")
	
	else:
		if attack_inProgress == false:	
			animated_sprite.play("idle")
	
func jump_logic():
		if Input.is_action_just_pressed("jump"):
			if is_on_floor() or jumps_left > 0:
				jump_when_launched(jump_force + 10)
				jumps_left -= 1
			if is_on_floor():
				jumps_left = max_jumps
				launched = false

func jump_when_launched(force):
	velocity.y = -force
	jumps_left = max_jumps - 1
	launched = true


func _on_player_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range && enemy_attack_cooldown == true:
		health -= 10
		enemy_attack_cooldown = false
		$enemy_cooldowm.start()
		print(health)

func _on_enemy_cooldowm_timeout():
	enemy_attack_cooldown = true

func player_died():
	if health <= 0:
		health = 0
		print("Player looses!")
		self.queue_free()
		#Add the die animation animated_sprite.play("died")
		#Add the extra life function
		#Add the go to menu screen function


func attack():
	if Input.is_action_just_pressed("primary_attack"):
		Global.player_attacking = true
		attack_inProgress = true
		animated_sprite.play("primary_attack")
		$make_attack.start()
		
func _on_make_attack_timeout():
	$make_attack.stop()
	Global.player_attacking = false
	attack_inProgress = false
