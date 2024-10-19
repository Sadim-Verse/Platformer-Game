extends Area2D



var player_detected = false

func start_dialogue():
	if player_detected:
		run_dialogue("npc_man1")
	

func run_dialogue(dialogue_string):
	
	Dialogic.Styles.load_style("New_style")
	var layout = Dialogic.start(dialogue_string)
	layout.register_character(load("res://Dialogues/NPC_MAN1.dch"), $".")
	#Dialogic.end_timeline()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = true
		start_dialogue()
		print("Entered!")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_detected = false
		print("Exited!")
