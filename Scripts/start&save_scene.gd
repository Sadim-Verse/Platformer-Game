extends StaticBody2D

@onready var spawn_pos = $Spawn_position

func get_spawn_pos():
	return spawn_pos.global_position
