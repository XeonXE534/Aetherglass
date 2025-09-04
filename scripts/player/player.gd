extends CharacterBody2D 

var attacking: bool = false
var jumping: bool = false
var direction2: bool = false

@onready var animation = $Animations

func _ready() -> void:
	print("PLAYER LOADED")
	animation.play("Idle")

func _process(_delta: float) -> void:
	_AnimationLogic()

func _physics_process(_delta: float) -> void:
	_Gravity()
	_Jump()
	_Movement()

func _Gravity(): 
	if not is_on_floor():
		velocity.y += G.P_GRAVITY

	elif is_on_ceiling():
		velocity.y += G.P_GRAVITY * 2

	elif is_on_floor():
		velocity.y = 0

func _Jump(): 
	if Input.is_action_just_pressed("W") and is_on_floor() and attacking == false:
		velocity.y = G.P_JUMP_VELOCITY
		jumping = true

func _Movement(): 
	var direction := Input.get_axis("A", "D")

	if direction:
		velocity.x = direction * G.P_SPEED

		if direction > 0:
			direction2 = false

		elif direction < 0:
			direction2 = true

	else:
		velocity.x = move_toward(velocity.x, 0, G.P_SPEED)
	move_and_slide()

func _AnimationLogic(): 
	if attacking: 
		#animation.play("Atk-1")
		pass
		
	elif not is_on_floor(): 

		if jumping:
			#animation.play("Jump")
			pass
		if velocity.y >= 10:
			#animation.play("Fall")
			pass
			
	elif is_zero_approx(velocity.x): 
		animation.play("Idle")

	else:
		animation.play("Run") 
		
	animation.flip_h = direction2
