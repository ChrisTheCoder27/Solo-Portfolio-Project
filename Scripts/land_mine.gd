extends Area2D

@onready var player_ui = $"../../CanvasLayer/PlayerUI"
@export var mine_power = 10.0

func _on_land_mine_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_ui.take_damage(mine_power)
		queue_free()
