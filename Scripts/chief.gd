extends CharacterBody2D


var player_detected = false

func start_dialogue():
	if player_detected:
		run_dialogue("chief")
	

func run_dialogue(dialogue_string):
	
	Dialogic.start(dialogue_string)
	#Dialogic.end_timeline()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = true
		start_dialogue()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = false
