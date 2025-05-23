extends RigidBody2D

@export var speed: float = 500.0
@export var direction: Vector2 = Vector2.RIGHT

func set_direction(dir: Vector2):
	direction = dir.normalized()
	linear_velocity = direction * speed

func set_speed(spd: float):
	speed = spd
	linear_velocity = direction * speed

func _ready():
	gravity_scale = 0.0
	contact_monitor = true
	max_contacts_reported = 4

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)

		if collider:
			if collider.has_method("take_damage"):
				collider.take_damage(1)
			queue_free()
			break
