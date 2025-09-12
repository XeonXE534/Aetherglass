extends Node

func _ready() -> void:
        print("GLOBALS LOADED - 1")
        
# Player vars and consts
@export var PLAYER_SPEED: float = 350.0
@export var PLAYER_JUMP_VELOCITY: float = -500.0
@export var PLAYER_GRAVITY: int = 20

# Elementalball vars and consts
@export var ELEMENTAL_BALLS_SPEED: float = 350.0

# Golem vars and consts
@export var GOLEM_SPEED: float = 100.0