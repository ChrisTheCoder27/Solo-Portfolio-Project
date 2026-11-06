extends Area2D

@onready var player_ui = $"../../CanvasLayer/PlayerUI"
@export var mine_power = 10.0
@export var knockback_force = 15.0

func _on_land_mine_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		player_ui.take_damage(mine_power)
		# Apply knockback based on the player's position
		body.velocity += (body.position - position) * knockback_force
		queue_free()
