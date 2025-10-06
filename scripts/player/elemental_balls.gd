extends Area2D

@onready var _states = $States
@onready var _timer = $Timer
@onready var _base_damage: int = 10
@onready var _player = get_tree().get_first_node_in_group("player")

var _velocity: Vector2 = Vector2.ZERO
var direction: Vector2
var _element_enum: int = 0

func _ready() -> void:
	if GameConfig.CUTSCENE == false:
		var element_string = GameConfig.PLAYER.get("element", "wind")
		_element_enum = GameConfig.StringToElement(element_string)

		_states.play(element_string)
		_timer.start()
		direction = (global_position - _player.global_position).normalized()

func _process(delta: float) -> void:
	if GameConfig.CUTSCENE == false:
		_velocity = _velocity.move_toward(
			direction * GameConfig.PROJECTILES["elemental_ball"]["speed"], 
			GameConfig.PROJECTILES["elemental_ball"]["accel"] * delta
		)
		position += _velocity * delta

func _on_Timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		ElementSynergy.ApplySimpleDmg(body, _base_damage, _element_enum)
		queue_free()
