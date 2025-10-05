extends Node

enum Element {
	FIRE,
	WATER,
	EARTH,
	WIND,
	LIGHT,
	DARK
}

var element_properties = {
	Element.FIRE: {
		"state": "energy",
		"tags": ["hot", "ignite", "dry"],
		"color": Color.ORANGE_RED
	},
	Element.WATER: {
		"state": "liquid",
		"tags": ["wet", "flow", "conduct"],
		"color": Color.DODGER_BLUE
	},
	Element.EARTH: {
		"state": "solid",
		"tags": ["heavy", "slow", "dense"],
		"color": Color.SADDLE_BROWN
	},
	Element.WIND: {
		"state": "gas",
		"tags": ["light", "fast", "push"],
		"color": Color.LIGHT_GRAY
	},
	Element.LIGHT: {
		"state": "special",
		"tags": ["pure", "reveal", "heal"],
		"color": Color.WHITE
	},
	Element.DARK: {
		"state": "special",
		"tags": ["corrupt", "drain", "hide"],
		"color": Color.BLACK
	}
}

var weaknesses = {
	Element.FIRE: [Element.WATER],
	Element.WATER: [Element.FIRE],
	Element.EARTH: [Element.WIND],
	Element.WIND: [Element.EARTH],
	Element.LIGHT: [Element.DARK],
	Element.DARK: [Element.LIGHT]
}

var resistances = {
	Element.FIRE: [Element.FIRE],
	Element.WATER: [Element.WATER],
	Element.EARTH: [Element.EARTH],
	Element.WIND: [Element.WIND],
	Element.LIGHT: [Element.LIGHT],
	Element.DARK: [Element.DARK]
}

var combo_effects = {
	"fire+water": {
		"name": "Steam",
		"damage_mult": 1.3,
		"effect": "create_steam_cloud",
		"description": "Creates obscuring steam, deals DOT"
	},

	"fire+earth": {
		"name": "Lava",
		"damage_mult": 1.5,
		"effect": "create_lava_pool",
		"description": "Persistent ground hazard"
	},

	"water+wind": {
		"name": "Ice Storm",
		"damage_mult": 1.2,
		"effect": "apply_freeze",
		"description": "Slows and damages over time"
	},

	"earth+wind": {
		"name": "Sandstorm",
		"damage_mult": 1.1,
		"effect": "apply_blind",
		"description": "Reduces enemy accuracy, small AOE"
	},

	"fire+wind": {
		"name": "Wildfire",
		"damage_mult": 1.4,
		"effect": "spread_burning",
		"description": "Fire spreads to nearby enemies"
	},

	"water+earth": {
		"name": "Mud",
		"damage_mult": 0.9,
		"effect": "apply_slow",
		"description": "Heavy slow, reduces movement by 70%"
	},

	"light+dark": {
		"name": "Void",
		"damage_mult": 2.5,
		"effect": "true_damage",
		"description": "Ignores all resistances, huge mana cost"
	},
	
	"fire+water+wind": {
		"name": "Hurricane",
		"damage_mult": 2.0,
		"effect": "screen_clear",
		"description": "Massive AOE, knocks back all enemies"
	}
}

func _ready() -> void:
	print("GLOBALS LOADED - 3/3 [Element System]")

func GET_MULTIPLIER(defender_element: int, attack_element: int) -> float:
	if attack_element in weaknesses.get(defender_element, []):
		return 2.0
	
	if attack_element in resistances.get(defender_element, []):
		return 0.5
	
	return 1.0

func COMBINE_ELEMENTS(elements: Array) -> Dictionary:
	if elements.size() == 0:
		push_error("No elements provided for combination")
		return {}
	
	if elements.size() == 1:
		return {
			"name": Element.keys()[elements[0]],
			"elements": elements,
			"damage_mult": 1.0,
			"effect": "none"
		}
	
	var sorted_elements = elements.duplicate()
	sorted_elements.sort()
	var combo_key = "+".join(_elements_to_strings(sorted_elements))
	
	if combo_key in combo_effects:
		var combo = combo_effects[combo_key].duplicate()
		combo["elements"] = elements
		return combo
	
	return {
		"name": "Multi-Element",
		"elements": elements,
		"damage_mult": 0.8 * elements.size(),  
		"effect": "none",
		"description": "Unfocused elemental energy"
	}

func APPLY_ELEMENTAL_DAMAGE(enemy: Node, base_damage: int, spell_data: Dictionary) -> void:
	if not enemy.has_method("TakeDamage"):
		push_error("Enemy does not have TakeDamage method")
		return
	
	var final_damage = base_damage
	var avg_multiplier = 1.0
	
	if enemy.has_method("get_element"):
		var enemy_element = enemy.get_element()
		var total_mult = 0.0
		
		for atk_element in spell_data.get("elements", []):
			total_mult += GET_MULTIPLIER(enemy_element, atk_element)
		
		avg_multiplier = total_mult / spell_data["elements"].size()

	var combo_mult = spell_data.get("damage_mult", 1.0)
	final_damage = int(base_damage * avg_multiplier * combo_mult)
	
	enemy.TakeDamage(final_damage)
	
	var effect = spell_data.get("effect", "none")
	if effect != "none" and enemy.has_method("apply_status"):
		enemy.apply_status(effect)
	
	_update_debug(enemy, spell_data, avg_multiplier, combo_mult, final_damage)

func _elements_to_strings(elements: Array) -> Array:
	var strings = []
	for elem in elements:
		strings.append(Element.keys()[elem].to_lower())
	return strings

func _update_debug(enemy: Node, spell_data: Dictionary, elem_mult: float, combo_mult: float, damage: int) -> void:
	var debug = get_tree().get_first_node_in_group("debug")
	if debug:
		if enemy.has_method("get_element"):
			debug.update_enemy_element(Element.keys()[enemy.get_element()])
		debug.update_spell_combo(spell_data.get("name", "Unknown"))
		debug.update_effectiveness(elem_mult * combo_mult)
		debug.update_damage(damage)