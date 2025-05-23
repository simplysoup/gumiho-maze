extends Node2D

@export var enemy_scene = preload("res://assets/scenes/enemy.tscn")
@export var coin_scene = preload("res://assets/scenes/coin.tscn")
@export var spawn_area: Rect2 = Rect2(Vector2(-100, -100), Vector2(100, 100))
@export var max_spawn_radius = 1000
@export var min_spawn_radius = 300
@export var max_spawns = 3
@export var spawn_interval_seconds = 3.0

func _ready():
	randomize()

func _process(_delta: float):
	var players = get_tree().get_nodes_in_group("player")
	if players:
		for player in players:
			await get_tree().create_timer(spawn_interval_seconds).timeout
			if get_tree().get_nodes_in_group("enemy").size() < max_spawns:
				spawn_enemy(player)

func spawn_enemy(player):
	var enemy = enemy_scene.instantiate()
	
	var radius = randf_range(min_spawn_radius, max_spawn_radius)
	var angle = randf_range(0, 2*PI)
	var pos = Vector2(
		radius * cos(angle),
		radius * sin(angle)
	)
	enemy.position = pos + player.position
	enemy.died.connect(_enemy_died)
	add_child(enemy)
	
func _enemy_died(enemy):
	var coin = coin_scene.instantiate()
	coin.position = enemy.position
	add_child(coin)
