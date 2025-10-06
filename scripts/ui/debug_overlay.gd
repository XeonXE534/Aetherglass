# Written by Claude AI
extends CanvasLayer

@onready var hp_label = $VBoxContainer/HPLabel
@onready var dmg_label = $VBoxContainer/DamageLabel
@onready var player_element_label = $VBoxContainer/PlayerElementLabel
@onready var enemy_element_label = $VBoxContainer/EnemyElementLabel
@onready var velocity_label = $VBoxContainer/VelocityLabel
@onready var effectiveness_label = $VBoxContainer/EffectivenessLabel
@onready var spell_combo_label = $VBoxContainer/SpellComboLabel

var last_damage: int = 0

func _ready() -> void:
	print("DEBUG LOADED [Debug Overlay]")
	UpdatePlayerElement()

# === PLAYER ===
func UpdatePlayerElement() -> void:
	var element = GameConfig.PLAYER.get("element", "none")
	player_element_label.text = "Player Element: %s" % element.capitalize()

func UpdatePlayerVelocity(velocity: Vector2) -> void:
	velocity_label.text = "Player Velocity: (%.2f, %.2f)" % [velocity.x, velocity.y]

# === ENEMY ===
func UpdateEnemyHP(current: int, enemy_max: int) -> void:
	hp_label.text = "Enemy HP: %d / %d" % [current, enemy_max]

func UpdateEnemyElement(element: String) -> void:
	enemy_element_label.text = "Enemy Element: %s" % element.capitalize()

# === COMBAT ===
func UpdateDamage(amount: int) -> void:
	last_damage = amount
	dmg_label.text = "Damage Dealt: %d" % amount

func UpdateEffectiveness(multiplier: float) -> void:
	var text = ""
	
	if multiplier >= 2.0:
		text = "Effectiveness: Super Effective! (%.1fx) :3" % multiplier
	elif multiplier > 1.0:
		text = "Effectiveness: Effective (%.1fx) :)" % multiplier
	elif multiplier == 1.0:
		text = "Effectiveness: Normal (1.0x) :/"
	elif multiplier > 0.0:
		text = "Effectiveness: Resist (%.1fx) :(" % multiplier
	else:
		text = "Effectiveness: tf is this???? (%.1fx) (o_o)!?" % multiplier
	
	effectiveness_label.text = text

func UpdateSpellCombo(combo_name: String) -> void:
	if spell_combo_label:
		spell_combo_label.text = "Spell: %s" % combo_name
