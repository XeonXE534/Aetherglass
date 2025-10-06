extends Node

@onready var CUTSCENE: bool = false
var count = 0

func _ready() -> void:
	print("GLOBALS LOADED - 1/3 [Game Config]")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('1'):
		CUTSCENE = true
		count += 1
	if count >= 2:
		CUTSCENE = false
		count = 0

var PLAYER = {
	"speed": 200.0,
	"jump_velocity": -500.0,
	"gravity": 20.0,
	"max_health": 200,
	"selected_elements": [ElementSynergy.Element.WIND],
}

const ENEMIES = {
	"golem": {
		"speed": 100.0,
		"max_health": 50,
		"attack_damage": 10,
		"attack_cooldown": 1.5,
		"detection_range": 300.0,
		"attack_range": 50.0,
		"element": ElementSynergy.Element.EARTH
	},
	"slime": {
		"speed": 100.0,
		"max_health": 50,
		"attack_damage": 10,
		"attack_cooldown": 1.5,
		"detection_range": 300.0,
		"attack_range": 50.0,
		"element": ElementSynergy.Element.WATER
	}
}

const PROJECTILES = {
	"elemental_ball": {
		"speed": 600.0,
		"accel": 2000.0
	}
}

func StringToElement(elem_str: String) -> int:
	match elem_str.to_lower():
		"fire": return ElementSynergy.Element.FIRE
		"water": return ElementSynergy.Element.WATER
		"earth": return ElementSynergy.Element.EARTH
		"wind": return ElementSynergy.Element.WIND
		"light": return ElementSynergy.Element.LIGHT
		"dark": return ElementSynergy.Element.DARK
	return ElementSynergy.Element.NONE