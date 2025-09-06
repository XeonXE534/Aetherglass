extends Area2D

var direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
    position += direction * G.WATERBALL_SPEED * delta

func _on_Timer_timeout() -> void:
    queue_free()

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("enemies"):
        body.TakeDamage(10)
        print('hit')
        queue_free()