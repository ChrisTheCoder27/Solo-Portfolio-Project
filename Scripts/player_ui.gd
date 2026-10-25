extends Control

# Fuel variables
@export var max_fuel : float = 100.0
var current_fuel : float
@export var drain_rate : float = 2.5
@export var fuel_increase : float = 20.0

# Health variables
@export var max_health : float = 100.0
var current_health : float

func _ready() -> void:
	current_fuel = max_fuel
	current_health = max_health

func _process(delta: float) -> void:
	$FuelBar.value = current_fuel
	$HealthBar.value = current_health
	
	if current_fuel > 0.0:
		current_fuel -= delta * drain_rate
	else:
		print("Out of fuel!")

func increase_fuel() -> void:
	current_fuel += fuel_increase
	if current_fuel > max_fuel:
		current_fuel = max_fuel

func take_damage(damage) -> void:
	current_health -= damage
	if (current_health <= 0):
		get_tree().reload_current_scene.call_deferred()
