extends Area2D



func _on_body_entered(body: Node2D) -> void:
	Global.Player_Entered_Deathzone()
