extends Area2D

var direction = Vector2.RIGHT
var speed = 600

func set_direction(dir: Vector2):
	direction = dir.normalized()
	
func _physics_process(delta):
	var direction = Vector2.ZERO
	position += direction * speed * delta

func _on_Arrow_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()




	
