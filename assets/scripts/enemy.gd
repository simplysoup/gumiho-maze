extends CharacterBody2D


const speed = 100.0
@export var max_health = 3
@export var health = max_health

func _ready():
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	var direction = direction_to_nearest_player()
	velocity = direction.normalized() * speed
	move_and_slide()
		
func take_damage(dmg: int):
	health -= dmg
	$ProgressBar.set_value_no_signal(health*$ProgressBar.max_value/max_health)
	if health <= 0:
		queue_free()

func direction_to_nearest_player():
	var min_dist = INF
	var nearest_player
	for player in get_tree().get_nodes_in_group("player"):
		print(player)
		var dist = (player.position - position).length()
		if dist < min_dist:
			nearest_player = player
			
	var dir
	if nearest_player:
		dir = nearest_player.position - position
	else:
		dir = Vector2.ZERO
	
	return dir
	
