extends CharacterBody2D 

var attacking: bool = false
var jumping: bool = false
var direction2: bool = false

@onready var animation = $Animations
@onready var hp = $HP/MarginContainer/TextureProgressBar

func _ready() -> void:
	hp.value = 100
	print("PLAYER LOADED")
	animation.play("Idle")

func _process(_delta: float) -> void:
	_AnimationLogic()
	_Health()

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
		#Attack animations are here but not implemented cuz magic system isnt here yet
		pass
			
	elif is_zero_approx(velocity.x): 
		animation.play("Idle")

	else:
		animation.play("Run") 
		
	animation.flip_h = direction2

func _Health():
	if Input.is_action_just_pressed("J"):
		hp.value = clamp(hp.value - 5, hp.min_value, hp.max_value)
		
		if hp.value == 0:
			animation.play("Death")
			queue_free()
