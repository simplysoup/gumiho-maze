extends CharacterBody2D

@export var max_health = 3
@export var speed = 100.0
var health
var knockback_timer = 0
var knockback_vector = Vector2.ZERO
var last_dir = Vector2.DOWN
signal died(who)

func _ready():
	add_to_group("enemy")
	health = max_health

func _physics_process(delta: float) -> void:
	if velocity.length() > 1:
		last_dir = velocity
	else:
		last_dir = last_dir

	var direction = direction_to_nearest_player()
	velocity = direction.normalized() * speed
	handle_animation(velocity, last_dir)
	handle_knockback(delta)
	move_and_slide()
		
func take_damage(dmg: int):
	health -= dmg
	$ProgressBar.set_value_no_signal(health*$ProgressBar.max_value/max_health)
	if health <= 0:
		emit_signal("died", self)
		queue_free()
		
func handle_knockback(delta):
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity += knockback_vector
		knockback_vector = knockback_vector * 0.5
		
func handle_animation(vel, dir):
	if vel.length() == 0:
		if dir.y >= 0:
			$AnimatedSprite2D.play("idle_down")
		else:
			$AnimatedSprite2D.play("idle_up")
	else:
		if vel.y > 0:
			$AnimatedSprite2D.play("walk_down")
		if vel.y < 0:
			$AnimatedSprite2D.play("walk_up")
		if vel.y == 0 and vel.x > 0:
			$AnimatedSprite2D.play("walk_down")
		if vel.y == 0 and vel.x <= 0:
			$AnimatedSprite2D.play("walk_down")
		

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
	
func apply_knockback(from_position: Vector2, strength := 500.0, duration = 0.2):
	var direction = (position - from_position).normalized()
	knockback_timer = duration
	knockback_vector = direction * strength
	
