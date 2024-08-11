extends Area2D

@onready var animated_sprite = $spriteSheet

@export var jump_force = 300


func _on_body_entered(body):
	if body.is_in_group("player") || not body.launched:
		animated_sprite.play("jump")
		body.jump_when_launched(jump_force)
