extends CharacterBody2D

@export var speed = 200
@export var Arrow = preload("res://assets/scenes/arrow.tscn")
var screen_size
var last_dir

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	last_dir = velocity
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
		shoot()
		
	if velocity.length() == 0:
		$AnimatedSprite2D.play("idle")
		$Bow.rotation = last_dir.angle()
	else:
		$Bow.rotation = velocity.angle()
	
	velocity = velocity.normalized() * speed
	
	move_and_slide()

func shoot():
	if Arrow == null:
		print("Arrow scene not assigned!")
		return
	var arrow = Arrow.instantiate()
	owner.add_child(arrow)
	arrow.global_position = $Bow.global_position
	if velocity.length() == 0:
		arrow.rotation = last_dir.angle()
	else:
		arrow.rotation = velocity.angle()
	
