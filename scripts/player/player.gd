extends CharacterBody2D 

var attacking: bool = false
var jumping: bool = false
var direction2: bool = false

@onready var animation = $Animations
@onready var hp = $HP/MarginContainer/TextureProgressBar

func _ready() -> void:
	hp.value = 100
	animation.play("Idle")

func _process(_delta: float) -> void:
	_AnimationLogic()
	_Health()

func _physics_process(_delta: float) -> void:
	_Gravity()
	_Jump()
	_Movement()
	_Attack()

func _Attack():
	if Input.is_action_just_pressed("SPACE") and not attacking:
		print('Attacked')
		attacking = true
		$AtkTimer.start()
		_ShootProjectile()

func _on_AtkTimer_timeout():
	attacking = false

func _ShootProjectile():
	var projectile = preload("res://scenes/player/elemental_balls.tscn").instantiate()
	get_parent().add_child(projectile)
	projectile.position = position
	
	if direction2:
		projectile.direction = Vector2.LEFT
	else:
		projectile.direction = Vector2.RIGHT
	
func _Gravity(): 
	if not is_on_floor():
		velocity.y += G.PLAYER_GRAVITY
	else:
		velocity.y = 0

func _Jump(): 
	if Input.is_action_just_pressed("W") and is_on_floor() and attacking == false:
		velocity.y = G.PLAYER_JUMP_VELOCITY
		jumping = true

func _Movement(): 
	var direction := Input.get_axis("A", "D")

	if direction:
		velocity.x = direction * G.PLAYER_SPEED

		if direction > 0:
			direction2 = false

		elif direction < 0:
			direction2 = true

	else:
		velocity.x = move_toward(velocity.x, 0, G.PLAYER_SPEED)
	move_and_slide()

func _AnimationLogic():
	if attacking:
		if animation.animation != "Charge_smoll_1_wa":
			animation.play("Charge_smoll_1_wa")
			
	elif is_zero_approx(velocity.x):
		if animation.animation != "Idle":
			animation.play("Idle")
			
	else:
		if animation.animation != "Run":
			animation.play("Run")

	animation.flip_h = direction2

func _Health():
	if Input.is_action_just_pressed("J"):
		hp.value = clamp(hp.value - 5, hp.min_value, hp.max_value)
		
		if hp.value <= 0:
			animation.play("Death")
			queue_free()
