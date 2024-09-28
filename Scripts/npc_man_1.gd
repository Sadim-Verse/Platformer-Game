extends Area2D



var player_detected = false

func _process(_delta):
	if player_detected:
		run_dialogue("npc_man1")
	

func run_dialogue(dialogue_string):
	
	Dialogic.start(dialogue_string)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = true
		print("Entered!")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = false
		print("Exited!")
