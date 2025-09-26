extends CanvasLayer

@onready var hp_label = $VBoxContainer/HPLabel
@onready var dmg_label = $VBoxContainer/DamageLabel
@onready var player_element_label = $VBoxContainer/PlayerElementLabel
@onready var enemy_element_label = $VBoxContainer/EnemyElementLabel
@onready var velocity_label = $VBoxContainer/VelocityLabel
@onready var effectiveness_label = $VBoxContainer/EffectivenessLabel

var last_damage: int = 0

func _ready() -> void:
	print("DEBUG LOADED [Debug Overlay]")
	update_player_element()

# --- Player ---
func update_player_element() -> void:
	player_element_label.text = "Player Element: %s" % GameConfig.PLAYER["element"]

func update_player_velocity(velocity: Vector2) -> void:
	velocity_label.text = "Player Velocity: (%.2f, %.2f)" % [velocity.x, velocity.y]

# --- Enemy ---
func update_enemy_hp(current: int, enemy_max: int) -> void:
	hp_label.text = "Enemy HP: %d / %d" % [current, enemy_max]

func update_enemy_element(element: String) -> void:
	enemy_element_label.text = "Enemy Element: %s" % element

# --- Combat ---
func update_damage(amount: int) -> void:
	last_damage = amount
	dmg_label.text = "Damage Dealt: %d" % amount

func update_effectiveness(multiplier: float) -> void:
	match multiplier:
		2.0:
			effectiveness_label.text = "Effectiveness: Effective! :3"
		1.0:
			effectiveness_label.text = "Effectiveness: Normal :/"
		0.5:
			effectiveness_label.text = "Effectiveness: Resist :("
		_:
			effectiveness_label.text = "Effectiveness: tf is this???? (o_o)!?"
