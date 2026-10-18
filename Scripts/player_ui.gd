extends Control

# Fuel variables
@export var max_fuel : float = 100.0
var current_fuel : float
@export var drain_rate : float = 2.5

func _ready() -> void:
	current_fuel = max_fuel

func _process(delta: float) -> void:
	$FuelBar.value = current_fuel
	if current_fuel > 0.0:
		current_fuel -= delta * drain_rate

func increase_fuel() -> void:
	current_fuel += 20.0
	if current_fuel > max_fuel:
		current_fuel = max_fuel
