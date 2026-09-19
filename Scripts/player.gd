extends CharacterBody2D

@export var speed : float = 300.0
@export var jump_velocity : float = -400.0
@export var dash_velocity : float = 900.0
@export var cooldown_time : float = 3.0
var dash_timer : float
var is_dashing : bool = false
var can_dash : bool = true
var prev_direction : int = 1

func _ready() -> void:
	$DashCooldownTimer.wait_time = cooldown_time
	$DashText.text = ""

func _process(delta: float) -> void:
	# If the player has dashed, the timer will decrease
	# until they can dash again
	if !can_dash:
		dash_timer -= delta
		$DashText.text = str(snapped(dash_timer, 0.1))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if is_dashing:
			velocity.x = direction * dash_velocity
		else:
			velocity.x = direction * speed
		
		if direction >= 0:
			prev_direction = 1
		else:
			prev_direction = -1
	else:
		if is_dashing:
			velocity.x = prev_direction * dash_velocity
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
	# Handle dash
	if Input.is_action_just_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		$DashTimer.start()
		$DashCooldownTimer.start()
		dash_timer = cooldown_time

	move_and_slide()

func _on_dash_timer_timeout() -> void:
	is_dashing = false

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	$DashText.text = ""
