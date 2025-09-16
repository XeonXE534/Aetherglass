extends Node

func _ready() -> void:
        print("GLOBALS LOADED - 1/3 [Game Config]")
        
# Player stats dictionary
const PLAYER = {
    "speed": 350.0,
    "jump_velocity": -500.0,
    "gravity": 20.0,
    "max_health": 100,
    "element": "fire"
}

# Enemy stats dictionary
const ENEMIES = {
    "golem": {
        "speed": 100.0,
        "max_health": 50,
        "attack_damage": 10,
        "attack_cooldown": 1.5,
        "detection_range": 300.0,
        "attack_range": 50.0,
        "element": "earth"
    },
    "slime": {
        "speed": 100.0,
        "max_health": 50,
        "attack_damage": 10,
        "attack_cooldown": 1.5,
        "detection_range": 300.0,
        "attack_range": 50.0,
        "element": "water"
    }
}

# Projectile stats dictionary
const PROJECTILES = {
    "elemental_ball": {
        "speed": 600.0,
        "accel": 2000.0
    }
}