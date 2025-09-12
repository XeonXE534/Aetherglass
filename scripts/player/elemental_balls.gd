extends Area2D

var direction: Vector2 = Vector2.ZERO

@onready var states = $States
@onready var timer = $Timer

func _ready() -> void:
	states.play('water')
	timer.start()

func _process(delta: float) -> void:
	position += direction * G.ELEMENTAL_BALLS_SPEED * delta
 
func _on_Timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.TakeDamage(10)
		queue_free()