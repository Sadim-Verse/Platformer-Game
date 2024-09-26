extends Area2D

@onready var player = $"../Player"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property($"../Player", "speed", 0, 0.5)
		get_tree().change_scene_to_file("res://Levels/new_level.tscn")
		#player.active = false
		print("exit!")
