extends Node

func _ready() -> void:
        print("GLOBALS LOADED")
        
#Player vars and consts
@export var P_SPEED: float = 250.0
@export var P_JUMP_VELOCITY: float = -500.0
@export var P_GRAVITY: int = 20

#Waterball vars and consts
@export var WATERBALL_SPEED: float = 100.0

#Golem vars and consts
@export var GOLEM_SPEED: float = 100.0