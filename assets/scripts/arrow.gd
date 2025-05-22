extends Area2D

var direction = Vector2.RIGHT
var speed = 600

func set_direction(dir: Vector2):
	direction = dir.normalized()
	
func _physics_process(delta):
	position += direction * speed * delta





	
