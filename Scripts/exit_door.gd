extends Area2D


func _ready():
	print("Body Entered!")

func _on_body_entered(body: Node2D) -> void:
	print("Body Entered!")
