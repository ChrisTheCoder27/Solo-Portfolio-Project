extends CharacterBody2D

# Movement variables
@export var speed : float = 300.0
var normal_speed : float
@export var jump_velocity : float = -400.0
@export var dash_velocity : float = 900.0
@export var cooldown_time : float = 3.0
@export var hover_speed : float = 150
@export var hover_time : float = 4.0
var dash_timer : float
var is_dashing : bool = false
var can_dash : bool = true
var prev_direction : int = 1
var is_hovering : bool = false

func _ready() -> void:
	normal_speed = speed
	$DashCooldownTimer.wait_time = cooldown_time
	$DashText.text = ""
	$HoverBar.max_value = hover_time

func _process(delta: float) -> void:
	# If the player has dashed, the timer will decrease
	# until they can dash again
	if !can_dash:
		dash_timer -= delta
		$DashText.text = str(snapped(dash_timer, 0.1))
	
	if !is_hovering and hover_time < $HoverBar.max_value:
		hover_time += delta
		$HoverBar.value = hover_time

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
		
		# Flips the player sprite depending on the direction they're facing
		if direction >= 0:
			prev_direction = 1
			$Sprite2D.flip_h = false
		else:
			prev_direction = -1
			$Sprite2D.flip_h = true
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
	
	# Handle hover
	if Input.is_action_pressed("hover") and !is_on_floor() and hover_time > 0.0:
		velocity.y = 0
		speed = hover_speed
		hover_time -= delta
		$HoverBar.value = hover_time
		is_hovering = true
	if Input.is_action_just_released("hover"):
		speed = normal_speed
		is_hovering = false
	
	move_and_slide()

func _on_dash_timer_timeout() -> void:
	is_dashing = false

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	$DashText.text = ""
