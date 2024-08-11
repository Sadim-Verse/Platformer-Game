extends Node2D

signal touchedPlayer

func _on_area_2d_body_entered(body):
	if body is Player:
		touchedPlayer.emit()
		
