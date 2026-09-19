extends Area2D

# Reloads the scene if the player falls
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene.call_deferred()
