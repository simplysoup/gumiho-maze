extends CharacterBody2D

@export var speed = 200.0
@export var max_health = 10
@export var knockback = 30
var Arrow = preload("res://assets/scenes/arrow.tscn")
var screen_size
var last_dir = Vector2.RIGHT
var health
var coins = 0
var knockback_timer = 0
var knockback_vector = Vector2.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("player")
	health = max_health
	
	$PickupArea.connect("area_entered", Callable(self, "_on_area_entered"))
	$PickupArea.connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	if velocity.length() > 1:
		last_dir = velocity
	else:
		last_dir = last_dir
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("walk_right"):
		velocity.x += 1
		#$AnimatedSprite2D.play("walk_right")
	if Input.is_action_pressed("walk_left"):
		velocity.x -= 1
		#$AnimatedSprite2D.play("walk_left")
	if Input.is_action_pressed("walk_up"):
		velocity.y -= 1
		$AnimatedSprite2D.play("walk_up")
	if Input.is_action_pressed("walk_down"):
		velocity.y += 1
		$AnimatedSprite2D.play("walk_down")
	if Input.is_action_just_pressed("attack_ranged"):
		shoot(position + velocity.normalized())
		
	if velocity.length() == 0:
		if last_dir.y >= 0:
			$AnimatedSprite2D.play("idle_down")
		else:
			$AnimatedSprite2D.play("idle_up")
			
	handle_knockback(delta)
	
	velocity = velocity.normalized() * speed
	
	move_and_slide()
	
func _on_area_entered(area):
	if area.is_in_group("coin"):
		coins += area.value
		area.queue_free()
		print("Coins: %d" % coins)

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.apply_knockback(position, 1000, 0.2)
		apply_knockback(body.position, 1000, 0.2)
		take_damage(body.damage)

func shoot(char_pos):
	if Arrow == null:
		return
	var arrow = Arrow.instantiate()
	
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = char_pos + Vector2(0, 2*abs(last_dir.normalized().x))
	if velocity.length() == 0:
		arrow.rotation = last_dir.angle()
		arrow.set_direction(last_dir)
	else:
		arrow.rotation = velocity.angle()
		arrow.set_direction(velocity)
		
func handle_knockback(delta):
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity += knockback_vector
		knockback_vector = knockback_vector * 0.5	

func take_damage(dmg: int):
	health -= dmg
	$ProgressBar.set_value_no_signal(health*$ProgressBar.max_value/max_health)
	if health <= 0:
		print("ya ded")

func apply_knockback(from_position: Vector2, strength := 100.0, duration = 0.2):
	var direction = (position - from_position).normalized()
	knockback_timer = duration
	knockback_vector = direction * strength
