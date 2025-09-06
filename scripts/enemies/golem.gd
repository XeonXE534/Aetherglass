extends CharacterBody2D



var player_position
var target
var direction: int = 1
var is_dead: bool = false
var can_damage: bool = true

@onready var player = get_parent().get_node('Player')
@onready var animation = $Animation
@onready var raycast = $RayCast2D
@onready var body_area = $Body
@onready var hp = $"HP-Basic E/MarginContainer/TextureProgressBar"


func _ready() -> void:
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
	print("HP:", hp.value)

	if hp.value <= 0:
		Die()

func Die():
	is_dead = true
	velocity = Vector2.ZERO
	animation.play("Death")
	queue_free()

func _Movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta  

	if velocity.x > 0:
		animation.flip_h = false

	elif velocity.x < 0:
		animation.flip_h = true
	
	else:
		animation.play("Idle")
		animation.flip_h = false

	move_and_slide()

func _on_DamageCooldown_timeout():
	can_damage = true
	
func _PlayerTracking():
	player_position = player.position
	target = (player_position - position).normalized()

	if position.distance_to(player_position) > 3:
		velocity.x = target.x * G.S_SPEED  
		animation.play("Run")

	else:
		velocity.x = 0  
		animation.play("Idle")
