extends Control

@onready var player = $"../../Player"

# Fuel variables
@export var max_fuel : float = 100.0
var current_fuel : float
@export var drain_rate : float = 2.5
@export var fuel_increase : float = 20.0
var fuel_empty : bool

# Health variables
@export var max_health : float = 100.0
var current_health : float

func _ready() -> void:
	current_fuel = max_fuel
	current_health = max_health
	fuel_empty = false

func _process(delta: float) -> void:
	$FuelBar.value = current_fuel
	$HealthBar.value = current_health
	
	if current_fuel > 0.0:
		current_fuel -= delta * drain_rate
		fuel_empty = true
	else:
		if !fuel_empty:
			#player.fuel_empty()
			fuel_empty = true
			get_tree().reload_current_scene.call_deferred()

func increase_fuel() -> void:
	current_fuel += fuel_increase
	if current_fuel > max_fuel:
		current_fuel = max_fuel

func take_damage(damage) -> void:
	current_health -= damage
	if (current_health <= 0):
		get_tree().reload_current_scene.call_deferred()
