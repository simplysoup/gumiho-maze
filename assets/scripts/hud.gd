extends CanvasLayer

var coins = 0

func _ready() -> void:
	$Coins.text = str(coins)

func _process(_delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		coins = player.coins
	$Coins.text = str(coins)
		
