extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("drop")
	$AnimatedSprite2D.play("loop")

func _process(delta: float) -> void:
	plasyer = get_tree().get_nodes_in_group("player")
