extends Node2D

@onready var _killzone = $killzone
@onready var _player = $Player

func _ready():
	_killzone.body_entered.connect(_on_killzone_body_entered)

func _on_killzone_body_entered(body):
	if body == _player:
		_player.queue_free()