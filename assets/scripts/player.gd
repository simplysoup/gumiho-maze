extends CharacterBody2D

@export var speed = 200.0
@export var max_health = 1
var Arrow = preload("res://assets/scenes/arrow.tscn")
var screen_size
var last_dir = Vector2.RIGHT
var health = max_health

func _ready() -> void:
	screen_size = get_viewport_rect().size
	add_to_group("player")

func _process(_delta: float) -> void:
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
		#$AnimatedSprite2D.play("walk_up")
	if Input.is_action_pressed("walk_down"):
		velocity.y += 1
		#$AnimatedSprite2D.play("walk_down")
	if Input.is_action_just_pressed("attack_ranged"):
		shoot(position + velocity.normalized())
		
	if velocity.length() == 0:
		$AnimatedSprite2D.play("idle")
	
	velocity = velocity.normalized() * speed
	
	move_and_slide()

func shoot(char_pos):
	if Arrow == null:
		print("Arrow scene not assigned!")
		return
	var arrow = Arrow.instantiate()
	
	get_tree().current_scene.add_child(arrow)
	arrow.global_position = char_pos
	if velocity.length() == 0:
		arrow.rotation = last_dir.angle()
		arrow.set_direction(last_dir)
	else:
		arrow.rotation = velocity.angle()
		arrow.set_direction(velocity)
	
func take_damage(dmg: int):
	health -= dmg
	$ProgressBar.set_value_no_signal(health*$ProgressBar.max_value/max_health)
	if health <= 0:
		queue_free()
