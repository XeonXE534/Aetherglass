extends Area2D

var direction: Vector2 = Vector2.ZERO

@onready var states = $States
@onready var timer = $Timer
@export var attack_element: String = "wind"
@export var base_damage: int = 10

func _ready() -> void:
	states.play(attack_element)
	timer.start()

func _process(delta: float) -> void:
	position += direction * GameConfig.ELEMENTAL_BALLS_SPEED * delta
 
func _on_Timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		ElementSynergy.APPLY_ELEMENTAL_DAMAGE(body, base_damage, attack_element)
		get_tree().get_first_node_in_group("debug").update_player_element(attack_element)

		queue_free()
