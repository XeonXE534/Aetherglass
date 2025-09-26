extends CharacterBody2D 

var attacking: bool = false
var jumping: bool = false
var direction2: bool = false

@onready var animation = $Animations
@onready var hp = $HP/MarginContainer/TextureProgressBar

func _ready() -> void:
	print("PLAYER LOADED")
	hp.value = GameConfig.PLAYER["max_health"]
	hp.max_value = GameConfig.PLAYER["max_health"]
	animation.play("Idle")

func _process(_delta: float) -> void:
	_AnimationLogic()
	_Health()
	_ElementSwitch()

func _physics_process(_delta: float) -> void:
	_Gravity()
	_Jump()
	_Movement()
	_Attack()

func _Attack():
	if Input.is_action_just_pressed("SPACE") and not attacking:
		attacking = true
		$AtkTimer.start()
		_ShootProjectile()

func _on_AtkTimer_timeout():
	attacking = false

func _ShootProjectile():
	var projectile = preload("res://scenes/player_atks/elemental_balls.tscn").instantiate()
	get_parent().add_child(projectile)
	projectile.position = position
	
	if direction2:
		projectile.direction = Vector2.LEFT
	else:
		projectile.direction = Vector2.RIGHT

func _Gravity(): 
	if not is_on_floor():
		velocity.y += GameConfig.PLAYER["gravity"]
	else:
		velocity.y = 0

func _Jump(): 
	if Input.is_action_just_pressed("W") and is_on_floor() and attacking == false:
		velocity.y = GameConfig.PLAYER["jump_velocity"]
		jumping = true

func _Movement():
	var direction := Input.get_axis("A", "D")

	if direction:
		velocity.x = direction * GameConfig.PLAYER["speed"]

		if direction > 0:
			direction2 = false

		elif direction < 0:
			direction2 = true

	else:
		velocity.x = move_toward(velocity.x, 0, GameConfig.PLAYER["speed"])

	move_and_slide()
	var debug = get_tree().get_first_node_in_group("debug")
	if debug:
		debug.update_player_velocity(velocity)
		
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
			OS.crash("Temp alpha death test")

var elements = ["fire", "water", "earth", "wind"]

func _ElementSwitch():
	if Input.is_action_just_pressed("TAB"):
		var current_idx = elements.find(GameConfig.PLAYER["element"])
		var next_idx = (current_idx + 1) % elements.size()

		GameConfig.PLAYER["element"] = elements[next_idx]
		
		var debug = get_tree().get_first_node_in_group("debug")
		if debug:
			debug.update_player_element()
