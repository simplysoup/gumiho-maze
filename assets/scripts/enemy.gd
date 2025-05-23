extends CharacterBody2D

@export var max_health = 3
@export var speed = 100.0
var health
signal died(who)

func _ready():
	add_to_group("enemy")
	health = max_health

func _physics_process(delta: float) -> void:
	var direction = direction_to_nearest_player()
	velocity = direction.normalized() * speed
	move_and_slide()
		
func take_damage(dmg: int):
	health -= dmg
	$ProgressBar.set_value_no_signal(health*$ProgressBar.max_value/max_health)
	if health <= 0:
		emit_signal("died", self)
		queue_free()

func direction_to_nearest_player():
	var min_dist = INF
	var nearest_player
	for player in get_tree().get_nodes_in_group("player"):
		var dist = (player.position - position).length()
		if dist < min_dist:
			nearest_player = player
			min_dist = dist
			
	var dir
	if nearest_player:
		dir = nearest_player.position - position
	else:
		dir = Vector2.ZERO
	
	return dir
	
