extends CharacterBody2D

const ANIM_IDLE = "Idle"
const ANIM_RUN = "Run"
const ANIM_HIT = "Hit"
const ANIM_DEATH = "Death"
const ANIM_ATTACK = "Atk-1"
const LOCKED_ANIMATIONS = [ANIM_HIT, ANIM_DEATH, ANIM_ATTACK]

var _player_position: Vector2
var _target: Vector2
var _direction: bool
var _is_dead: bool = false
var _attacking: bool = false
var _attack_range: float = 50.0

var element: String = "earth"

@onready var _player = get_parent().get_node("Player")
@onready var _animation = $Animation
@onready var _hp = $"HP-Basic E/MarginContainer/TextureProgressBar"
@onready var _atk_timer = $AtkTimer

var _atk_fx_basic = preload("res://scenes/FX/atk_fx_basic.tscn")

func _ready() -> void:
	print("GOLEM LOADED")
	_hp.value = _hp.max_value
	_animation.play(ANIM_IDLE)
	_player_position = _player.position

func _physics_process(delta: float) -> void:
	if _is_dead or GameConfig.CUTSCENE:
		return

	_Movement(delta)
	_PlayerTracking()
	_AttackLogic()

func _OnAnimationFinished() -> void:
	if _animation.animation == ANIM_HIT:
		_animation.play(ANIM_IDLE)
		
	elif _animation.animation == ANIM_DEATH:
		queue_free()

func TakeDamage(amount: int) -> void:
	if _is_dead:
		return
	
	_hp.value = clamp(_hp.value - amount, _hp.min_value, _hp.max_value)
	
	var debug = get_tree().get_first_node_in_group("debug")
	if debug:
		debug.update_enemy_hp(_hp.value, _hp.max_value)
		debug.update_damage(amount)

	if _hp.value <= 0:
		_is_dead = true
		$"HP-Basic E".visible = false
		_animation.play(ANIM_DEATH)

	else:
		_animation.play(ANIM_HIT)

func _AttackLogic() -> void:
	if _attacking or _is_dead:
		return

	if position.distance_to(_player_position) <= _attack_range:
		_attacking = true
		_atk_timer.start()
		_animation.play(ANIM_ATTACK)
		_PlayGroundFX("ground_stomp_1")

func _on_AtkTimer_timeout() -> void:
	_attacking = false

func _PlayGroundFX(anim_name: String) -> void:
	var fx_instance = _atk_fx_basic.instantiate()
	get_parent().add_child(fx_instance)

	fx_instance.position = Vector2(_player_position.x, _player_position.y)

	var sprite = fx_instance.get_node("Animations")
	sprite.animation = anim_name
	sprite.play()
	
	var damage_timer = Timer.new()
	damage_timer.wait_time = 0.3
	damage_timer.one_shot = true
	damage_timer.connect("timeout", Callable(self, "_DealDamageToPlayer"))
	add_child(damage_timer)
	damage_timer.start()

func _DealDamageToPlayer() -> void:
	if _is_dead:
		return

	if position.distance_to(_player.position) <= _attack_range:
		_player.TakeDamage(GameConfig.ENEMIES["golem"]["attack_damage"])

func _Movement(delta: float) -> void:
	if _is_dead:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity += get_gravity() * delta  

	_UpdateAnimation()
	move_and_slide()

func _PlayerTracking() -> void:
	_player_position = _player.position
	_target = (_player_position - position).normalized()

	if position.distance_to(_player_position) > _attack_range:
		velocity.x = _target.x * GameConfig.ENEMIES["golem"]["speed"]

	else:
		velocity.x = 0

func _UpdateAnimation() -> void:
	if _animation.animation in LOCKED_ANIMATIONS:
		return

	if velocity.x != 0:
		if _animation.animation != ANIM_RUN:
			_animation.play(ANIM_RUN)
		_direction = velocity.x < 0
		_animation.flip_h = _direction

	else:
		if _animation.animation != ANIM_IDLE:
			_animation.play(ANIM_IDLE)
		_animation.flip_h = _direction
