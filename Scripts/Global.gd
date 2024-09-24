extends Node

var player
var player_original_pos

func Player_Entered_Deathzone():
	player.position = player_original_pos


var player_attacking = false

var enemy_attacking = false

enum guns {AK, SHOTGUN, ROCKET}

const enemy_parameters = {
	'drone': {'speed': 110},
	'soldier': {'speed': 50}
}
