extends Node

func _ready() -> void:
	print("GLOBALS LOADED - 3/3 [Element Synergy]")

@export var weaknesses = {
	"fire"	:["water"],
	"water"	:["fire"],
	"earth"	:["wind"],
	"wind"	:["earth"]
}

@export var resistances = {
	"fire"	:["fire"],
	"water"	:["water"],
	"earth"	:["earth"],
	"wind"	:["wind"]
}

func GET_MULTIPLIER(enemy, attack_element: String) -> float:
	if enemy.is_in_group("light"):
		if attack_element == "dark":
			return 2.0

		elif attack_element == "light":
			return 1.0

		else:
			return 0.5

	elif enemy.is_in_group("dark"):
		if attack_element == "light":
			return 2.0

		elif attack_element == "dark":
			return 1.0
			
		else:
			return 0.5

	for weak_group in weaknesses.get(attack_element, []):
		if enemy.is_in_group(weak_group):
			return 2.0

	for resist_group in resistances.get(attack_element, []):
		if enemy.is_in_group(resist_group):
			return 0.5

	return 1.0

func APPLY_ELEMENTAL_DAMAGE(enemy: Node, base_damage: int, attack_element: String) -> void:
	var multiplier: float = GET_MULTIPLIER(enemy, attack_element)
	var final_damage: int = int(base_damage * multiplier)
	enemy.TakeDamage(final_damage)

	var debug = get_tree().get_first_node_in_group("debug")
	if debug:
		debug.update_enemy_element(enemy.element)
		debug.update_effectiveness(multiplier)
		debug.update_damage(final_damage)
