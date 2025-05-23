extends Node2D

@export var enemy_scene = preload("res://assets/scenes/enemy.tscn")
@export var spawn_area: Rect2 = Rect2(Vector2(-100, -100), Vector2(100, 100))
@export var max_spawns = 3
@export var spawn_interval_seconds = 3.0

func _ready():
	randomize()
	for i in range(max_spawns):
		spawn_enemy()

func _process(_delta: float):
	await get_tree().create_timer(spawn_interval_seconds).timeout
	if get_tree().get_nodes_in_group("enemy").size() < max_spawns:
		spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var pos = Vector2(
		randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
		randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	)
	enemy.position = pos
	add_child(enemy)
