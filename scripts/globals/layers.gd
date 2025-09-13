extends Node

func _ready() -> void:
        print("GLOBALS LOADED - 2/3 [Layers]")

# Collision layers
const PLAYER       = 1 << 0   # Layer 1
const BOSS         = 1 << 1   # Layer 2
const ENEMY_BASIC  = 1 << 2   # Layer 3
const GROUND       = 1 << 31  # Layer 32
