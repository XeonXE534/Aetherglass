extends Node2D

@onready var killzone = $killzone
@onready var player = $Player

func _ready():
	killzone.body_entered.connect(_on_killzone_body_entered)

func _on_killzone_body_entered(body):
	if body == player:
		player.queue_free()