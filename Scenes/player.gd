extends CharacterBody2D

signal shoot

const START_SPEED : int = 200
const BOOST_SPEED : int = 400
const NORMAL_SHOT : float = 0.5
const FAST_SHOT : float = 0.1
var speed : int
var can_shoot : bool
var screen_size : Vector2
@onready var laser_gun_sound = $"Laser gun sound"

func _ready():
	screen_size = get_viewport_rect().size
	reset()

func reset():
	can_shoot = true
	position = screen_size / 2
	speed = START_SPEED
	$"Shot Timer".wait_time = NORMAL_SHOT

func get_input():
	#keyboard input
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_dir.normalized() * speed
	
	#Mouse clicks
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var dir = get_global_mouse_position() - position
		laser_gun_sound.play()
		shoot.emit(position, dir)
		can_shoot = false
		$"Shot Timer".start()

func _physics_process(_delta):
	# Player movement.
	get_input()
	move_and_slide()

	#limit movement to window size
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#player rotation
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)
	angle = wrapi(int(angle), 0, 8)
	
	$AnimatedSprite2D.animation = "Walk" + str(angle)

	#player animation
	if velocity.length() != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 0

func boost():
	$"Boost Timer".start()
	speed = BOOST_SPEED

func quick_fire():
	$"Fast Shot Timer".start()
	$"Shot Timer".wait_time = FAST_SHOT

func _on_shot_timer_timeout():
	can_shoot = true

func _on_boost_timer_timeout():
	speed = START_SPEED

func _on_fast_shot_timer_timeout():
	$"Shot Timer".wait_time = NORMAL_SHOT
