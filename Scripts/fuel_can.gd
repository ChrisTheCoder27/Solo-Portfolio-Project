extends Area2D

@onready var player_ui = $"../CanvasLayer/PlayerUI"

func _on_fuel_can_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_ui.increase_fuel()
		queue_free()
