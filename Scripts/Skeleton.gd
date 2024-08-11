extends CharacterBody2D

@onready var animated_sprite = $enemy

@export var gravity = 500
@export var speed = 20
var player_chase = false
var player = null

@export var health = 100
var player_in_attack_range = false
var can_take_damage = true

func _physics_process(delta):
	
	movement(delta)
	deal_with_damage()
		
	move_and_slide()

func movement(delta):
	if is_on_floor() == false:
		velocity.y  += gravity * delta
		if velocity.y > 1000: velocity.y = 500
	
	if player_chase:
		position += (player.position - position)/speed
		animated_sprite.play("Walk")
		
		if (player.position.x - position.x) < 0:
			animated_sprite.set_flip_h(true)
		else:
			animated_sprite.set_flip_h(false)		
	else:
		animated_sprite.play("idle")

func animations():
	pass

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true 

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func _on_skeleton_hitbox_body_entered(body):
	if body.is_in_group("player"):
		player_in_attack_range = true

func _on_skeleton_hitbox_body_exited(body):
	if body.is_in_group("player"):
		player_in_attack_range = false
		
func deal_with_damage():
	if player_in_attack_range and Global.player_attacking == true:
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health: ", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
