extends CharacterBody2D 

const ATTACK_ANIMATIONS = ["Charge_smoll_1_wa"]
const LOCKED_ANIMATIONS = ["Hit", "Death"]
const ANIM_IDLE = "Idle"
const ANIM_RUN = "Run"
const ANIM_HIT = "Hit"
const ANIM_DEATH = "Death"
const ANIM_CHARGE = "Charge_smoll_1_wa"

var _attacking: bool = false
var _facingLeft: bool = false

var _elements = ["fire", "water", "earth", "wind"]

var _max_hp: int = GameConfig.PLAYER["max_health"]
var _hybrid_threshold: float = 0.0

@onready var animation = $Animations
@onready var hp = get_parent().get_node("HUD/MarginContainer/HP")

func _ready() -> void:
	print("PLAYER LOADED")
	hp.value = GameConfig.PLAYER["max_health"]
	hp.max_value = GameConfig.PLAYER["max_health"]
	_hybrid_threshold = _max_hp * 0.2
	animation.play(ANIM_IDLE)

func _process(_delta: float) -> void:
	if not GameConfig.CUTSCENE:
		_UpdateAnimation()
		_HandleElementSwitch()
		
func _physics_process(_delta: float) -> void:
	_ApplyGravity()
	if not GameConfig.CUTSCENE:
		_HandleJump()
		_HandleMovement()
		_HandleAttack()

func _on_Animations_finished() -> void:
	if animation.animation == ANIM_HIT:
		animation.play(ANIM_IDLE)

	elif animation.animation == ANIM_DEATH:
		queue_free()

func _HandleAttack() -> void:
	if Input.is_action_just_pressed("SPACE") and not _attacking and _CanCast():
		_attacking = true
		_UseMana(1.0)
		$AtkTimer.start()
		_ShootProjectile()

func _on_AtkTimer_timeout() -> void:
	_attacking = false

func _ShootProjectile() -> void:
	var projectile = preload("res://scenes/player_atks/elemental_balls.tscn").instantiate()
	get_parent().add_child(projectile)
	projectile.position = position
	projectile.direction = Vector2.LEFT if _facingLeft else Vector2.RIGHT

func TakeDamage(amount: float) -> void:
	hp.value = clamp(hp.value - amount, 0, _max_hp)

	if hp.value > 0:
		animation.play(ANIM_HIT)

	else:
		animation.play(ANIM_DEATH)

func _GetCurrentMana() -> float:
	if hp.value > _hybrid_threshold:
		return hp.value - _hybrid_threshold

	return 0.0

func _CanCast() -> bool:
	return hp.value > _hybrid_threshold

func _UseMana(cost: float) -> bool:
	if _CanCast() and _GetCurrentMana() >= cost:
		hp.value -= cost
		return true

	return false

func _ApplyGravity() -> void:
	if not is_on_floor():
		velocity.y += GameConfig.PLAYER["gravity"]

	else:
		velocity.y = 0

func _HandleJump() -> void:
	if Input.is_action_just_pressed("W") and is_on_floor() and not _attacking:
		velocity.y = GameConfig.PLAYER["jump_velocity"]

func _HandleMovement() -> void:
	var direction := Input.get_axis("A", "D")

	if direction:
		velocity.x = direction * GameConfig.PLAYER["speed"]
		_facingLeft = direction < 0

	else:
		velocity.x = move_toward(velocity.x, 0, GameConfig.PLAYER["speed"])

	move_and_slide()
	
	var debug = get_tree().get_first_node_in_group("debug")
	if debug:
		debug.update_player_velocity(velocity)

func _UpdateAnimation() -> void:
	if animation.animation in LOCKED_ANIMATIONS:
		return


	if _attacking:
		if animation.animation != ANIM_CHARGE:
			animation.play(ANIM_CHARGE)

	elif not is_zero_approx(velocity.x):
		if animation.animation != ANIM_RUN:
			animation.play(ANIM_RUN)

	else:
		if animation.animation != ANIM_IDLE:
			animation.play(ANIM_IDLE)

	animation.flip_h = _facingLeft

func _HandleElementSwitch() -> void:
	if Input.is_action_just_pressed("TAB"):
		var current_idx = _elements.find(GameConfig.PLAYER["element"])
		var next_idx = (current_idx + 1) % _elements.size()
		GameConfig.PLAYER["element"] = _elements[next_idx]
		
		var debug = get_tree().get_first_node_in_group("debug")
		if debug:
			debug.update_player_element()
