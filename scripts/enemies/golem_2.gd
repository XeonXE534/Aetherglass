extends CharacterBody2D

var _player_position
var _target
var _direction: bool
var _is_dead: bool = false
var _can_damage: bool = true
var element: String = "earth"

@onready var _player = get_parent().get_node('Player')
@onready var _animation = $Animation
@onready var _raycast = $RayCast2D
@onready var _body_area = $Body
@onready var _hp = $"HP-Basic E/MarginContainer/TextureProgressBar"

func _ready() -> void:
	print("GOLEM LOADED")
	_hp.value = _hp.max_value
	_animation.play("Idle")
	_player_position = _player.position

func _physics_process(delta: float) -> void:
	if GameConfig.CUTSCENE == false:
		_Movement(delta)
		_PlayerTracking()
	
func TakeDamage(amount: int) -> void:
	if _is_dead:
		return
	
	_hp.value = clamp(_hp.value - amount, _hp.min_value, _hp.max_value)
	get_tree().get_first_node_in_group("debug").update_enemy_hp(_hp.value, _hp.max_value)
	get_tree().get_first_node_in_group("debug").update_damage(amount)
	_animation.play("Hit")

	if _hp.value <= 0:
		_is_dead = true
		$"HP-Basic E".visible = false
		_animation.play("Death")

func _OnAnimationFinished() -> void:
	if _animation.animation == "Death":
		queue_free()

func _OnDamageCooldownTimeout():
	_can_damage = true
	
func _Movement(delta: float) -> void:
	if _is_dead:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity += get_gravity() * delta  

	if velocity.x > 0:		
		_animation.play("Run")
		_direction = false
		_animation.flip_h = _direction

	elif velocity.x < 0:
		_animation.play("Run")
		_direction = true
		_animation.flip_h = _direction
	
	else:
		_animation.play("Idle")
		_animation.flip_h = false

	move_and_slide()

func _PlayerTracking():
	if _is_dead:
		return

	_player_position = _player.position
	_target = (_player_position - position).normalized()

	if position.distance_to(_player_position) > 50:
		velocity.x = _target.x * GameConfig.ENEMIES["golem"]["speed"]

	else:
		_animation.flip_h = _direction
		velocity.x = 0  
		_animation.play("Idle")
