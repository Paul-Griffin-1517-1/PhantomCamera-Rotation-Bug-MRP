extends Marker3D

@onready var player_scene := preload("res://player.tscn")

var player : CharacterBody3D

func _ready():
	spawn_player.call_deferred()

func spawn_player():
	player = player_scene.instantiate()
	add_sibling(player)
	player.position = global_position
	## This code as is works in PhantomCamera v7.0.6. PP
	player.get_node("ThirdPersonCamera").on_load_camera_rotate(rotation_degrees.y)
