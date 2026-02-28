extends CharacterBody2D

# Movement constants
const SPEED = 200.0
const RUN_SPEED = 350.0
const JUMP_VELOCITY = -400.0

# State flags
var is_dead = false
var is_running = false

# Reference to AnimatedSprite2D
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		sprite.play("dead")
		return

	# Apply gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")

	# Shift key for running
	is_running = Input.is_key_pressed(KEY_SHIFT)

	# Movement input
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * (RUN_SPEED if is_running else SPEED)
		sprite.flip_h = direction < 0
		if not is_on_floor():
			sprite.play("jump")
		elif is_running:
			sprite.play("run")
		else:
			sprite.play("walk")
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		if not is_on_floor():
			sprite.play("jump")
		elif is_on_floor():
			sprite.play("idle")

	move_and_slide()

# Call this to trigger death from outside the script
func die():
	is_dead = true
