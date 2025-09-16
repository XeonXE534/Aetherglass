extends Area2D

@onready var states = $States
@onready var timer = $Timer
@export var attack_element: String = GameConfig.PLAYER["element"]
@export var base_damage: int = 10

@onready var player = get_tree().get_first_node_in_group("player")

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2

func _ready() -> void:
	states.play(attack_element)
	timer.start()
	direction = (global_position - player.global_position).normalized()

func _process(delta: float) -> void:
	velocity = velocity.move_toward(direction * GameConfig.PROJECTILES["elemental_ball"]["speed"], GameConfig.PROJECTILES["elemental_ball"]["accel"] * delta)
	position += velocity * delta

func _on_Timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		ElementSynergy.APPLY_ELEMENTAL_DAMAGE(body, base_damage, attack_element)
		queue_free()
