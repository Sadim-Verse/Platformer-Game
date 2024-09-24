extends Node2D

@export var next_level: PackedScene = null

@onready var start = $"Start&Save_scene"
@onready var exit = $Exit
@onready var deathZone = $Deathzone

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touchedPlayer.connect(_on_traps_touched_player)
		
	exit.body_entered.connect(on_exit_body_entered)
	#deathZone.body_entered.connect(_on_deathzone_body_entered)

func _process(_delta):
	input_actions()
	
	
func input_actions():
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	

#func _on_deathzone_body_entered(_body):
	#reset_player() 

func _on_traps_touched_player():
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	
func on_exit_body_entered(body):
	if body.is_in_group("player"):
		if next_level != null:
			exit.animate()
			player.active = false
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_packed(next_level)
	
