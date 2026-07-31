extends CharacterBody3D
# hi xavieeerrrrr
@onready var camera = $Camera3D
@onready var ray = $Camera3D/RayCast3D
 
@export var walk_speed = 4.5
var speed = walk_speed
@export var sprint_speed = 10
var sensitivity: float = 0.05

 
var look_x := 0.0 
var look_y := 0.0
 
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	PlayerManager.player = self
 
func _input(event):
	if event is InputEventMouseMotion:
		look_y -= event.relative.x * sensitivity
		look_x -= event.relative.y * sensitivity
 
		look_x = clamp(look_x, -80, 80)
 
		rotation_degrees.y = look_y 
		camera.rotation_degrees.x = look_x 
 
func _physics_process(delta: float):
	ray_scanning(delta)
	jumping(delta)
	movement(delta)
	move_and_slide()
 
func movement(delta):
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = walk_speed
		
	
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
 
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
 
func jumping(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
 
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = speed
 
func ray_scanning(delta):
	if ray.is_colliding():
		var collider = ray.get_collider()
 
		if Input.is_action_just_pressed("interact"):
			print("It's a " + collider.name)
 
			if collider.is_in_group("interactable"):
				collider.interact()
 
