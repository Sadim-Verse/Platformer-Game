extends Node

var player_attacking = false

var enemy_attacking = false

enum guns {AK, SHOTGUN, ROCKET}

const enemy_parameters = {
	'drone': {'speed': 110},
	'soldier': {'speed': 50}
}
