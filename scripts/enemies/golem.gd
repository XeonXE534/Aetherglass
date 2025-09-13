extends CharacterBody2D

var player_position
var target
var direction: bool
var is_dead: bool = false
var can_damage: bool = true

@onready var player = get_parent().get_node('Player')
@onready var animation = $Animation
@onready var raycast = $RayCast2D
@onready var body_area = $Body
@onready var hp = $"HP-Basic E/MarginContainer/TextureProgressBar"

@export var element: String = "earth"

func _ready() -> void:
	print("GOLEM LOADED")
	hp.value = hp.max_value
	animation.play("Idle")
	player_position = player.position

func _physics_process(delta: float) -> void:
	_Movement(delta)
	_PlayerTracking()
	
func TakeDamage(amount: int) -> void:
	if is_dead:
		return
	
	hp.value = clamp(hp.value - amount, hp.min_value, hp.max_value)
	get_tree().get_first_node_in_group("debug").update_enemy_hp(hp.value, hp.max_value)
	get_tree().get_first_node_in_group("debug").update_damage(amount)
	animation.play("Hit")

	if hp.value <= 0:
		is_dead = true
		$"HP-Basic E".visible = false
		animation.play("Death")


func _OnAnimationFinished() -> void:
	if animation.animation == "Death":
		queue_free()

func _OnDamageCooldownTimeout():
	can_damage = true
	
func _Movement(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity += get_gravity() * delta  

	if velocity.x > 0:		
		animation.play("Run")
		direction = false
		animation.flip_h = direction

	elif velocity.x < 0:
		animation.play("Run")
		direction = true
		animation.flip_h = direction
	
	else:
		animation.play("Idle")
		animation.flip_h = false

	move_and_slide()

func _PlayerTracking():
	if is_dead:
		return

	player_position = player.position
	target = (player_position - position).normalized()

	if position.distance_to(player_position) > 50:
		velocity.x = target.x * GameConfig.GOLEM_SPEED

	else:
		animation.flip_h = direction
		velocity.x = 0  
		animation.play("Idle")
