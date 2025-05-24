extends Area2D

@export var value = 1
var transitioned = false

func _ready() -> void:
	add_to_group("coin")
	$AnimatedSprite2D.play("drop")

func _process(delta: float) -> void:
	if $AnimatedSprite2D.animation == "drop" \
	and $AnimatedSprite2D.frame > 4:
		transitioned = true
		$AnimatedSprite2D.play("spin")
		
	if transitioned:
		var direction = direction_to_nearest_player()
		if direction.length() < 8:
			return

		var speed = min(500, 700 / direction.length())
		position += direction.normalized() * speed * delta


func direction_to_nearest_player():
	var min_dist = 70
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
