extends CharacterBody2D

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
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
		
	if velocity.length() == 0:
		$AnimatedSprite2D.play("idle")
	
	velocity = velocity.normalized() * speed
	
	# Move using move_and_slide (no argument is needed)
	move_and_slide()
	
	# Clamp the position to ensure it stays within the screen boundaries
	position = position.clamp(Vector2.ZERO, screen_size)
