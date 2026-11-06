extends Area2D

@onready var player_ui = $"../../CanvasLayer/PlayerUI"
var collected = false

func _on_fuel_can_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !collected:
		player_ui.increase_fuel()
		$PickupSound.play()
		$SoundTimer.start()
		visible = false
		collected = true


func _on_sound_timer_timeout() -> void:
	queue_free()
