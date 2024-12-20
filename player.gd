extends CharacterBody2D

var max_health: float = 20

var health: float = max_health:
	set(value): health = clampf(value, 0, max_health)
var x_skid = false

var max_accel: float = 20
var min_accel: float = 15
var accel: float: # linearly interpolate based on health
	get: return lerpf(min_accel, max_accel, health / max_health)
	
var max_speed: float = 600
var min_skid: float = 400

var jump_force: float = -625
var jumping = false

var grav_accel: float = 3;
var max_fall: float = 800

var original_pos: Vector2
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_pos = Vector2(position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass

func _physics_process(_delta: float) -> void:
	var prev_x_sign = signf(velocity.x)
	get_input();
	velocity.x = clampf(velocity.x, -max_speed, max_speed)
	velocity.y += 20
	velocity.y = clampf(velocity.y, -INF, max_fall)
	
	# round it down
	if(Global.basically_zero(velocity.x, 1)):
		velocity.x = 0
	
	if signf(velocity.x) != prev_x_sign || signf(velocity.x) == 0:
		x_skid = false
		
	move_and_slide();
	
	if jumping && is_on_floor():
		jumping = false
	
func get_input() -> void:
	var curr_accel = lerpf(accel, 0, velocity.length() / max_speed)
	
	var x_dir = 0
	if Input.is_action_pressed("ui_left"):
		#velocity.x -= accel
		x_dir -= 1
	if Input.is_action_pressed("ui_right"):
		#velocity.x += accel
		x_dir += 1
		
	if Input.is_action_just_pressed("ui_up") && !jumping:
		velocity.y += jump_force
		jumping = true
		
	if signf(x_dir) != signf(velocity.x) and velocity.length() > min_skid:
		x_skid = true
	if signf(x_dir) == signf(velocity.x) || !is_on_floor():
		x_skid = false
	
	if signf(x_dir) != signf(velocity.x) && !x_skid:
		curr_accel *= 1.5
		
	if !is_on_floor():
		curr_accel *= 1.25
		
	var x_accel = curr_accel * x_dir
			
	if x_skid:
		x_accel *= 0.6
	
	velocity.x += x_accel
	if x_skid:
		if x_dir == 0:
			velocity.x *= 0.85
		else:
			velocity.x *= 0.9
	elif x_dir == 0:
		velocity.x *= 0.7
	
	if Input.is_key_pressed(KEY_E):
		health += 0.5
	if Input.is_key_pressed(KEY_Q):
		health -= 0.5
		
	if Input.is_key_pressed(KEY_R):
		position = Vector2(original_pos)
