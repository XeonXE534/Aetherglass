# Aetherglass

## Overview

**Aetherglass** is a 2D action roguelite shooter built around deep, modular magic mechanics. Cast and combine spells dynamically to survive procedurally generated arenas filled with elemental hazards and relentless enemies. Every spell decision matters—your health IS your mana.

This is an open-source learning project focused on experimenting with emergent gameplay systems and skill-based combat design.

---

## Core Features

### **HP/Mana Hybrid System**

- The first 80% of your health bar doubles as mana
- Cast spells by spending health—every spell is a calculated risk
- The last 20% is pure HP—when you hit this zone, no more casting
- Forces aggressive, skill-based play: dodge well or run out of resources

### **Modular Element Combination System**

- Choose 3 base elements at the start of each arena run
- Cast single elements instantly, or combine 2-3 for devastating effects
- **Rule-based synergy**: Combos generate dynamically based on element properties (tags, states, temperatures)
- No hardcoded combo list—new elements create emergent interactions automatically
- Examples:
  - Fire + Water → Steam (obscuring clouds + DOT)
  - Fire + Earth → Lava (persistent ground hazard)
  - Water + Wind → Ice Storm (freeze + slow)
  - Fire + Water + Wind → Hurricane (massive AoE screen-clear)

### **Procedural Multi-Arena Structure**

- **4 Top-Level Arenas (TLAs)**: Fire, Water, Earth, Wind
  - Each themed around its element with matching enemies and hazards
  - Infinite procedurally generated sublevels within each TLA
- **Special Light/Dark Rifts**: Rare optional encounters with unique mechanics and high-risk/high-reward loot
- **Room-based progression**: Each room is a mini-arena with enemy waves, not slow dungeon exploration

### **Fast-Paced Arena Combat**

- High movement speed with tight dodge mechanics (i-frames, responsive controls)
- Enemy waves spawn aggressively—minimal downtime between fights
- Emphasis on positioning, timing, and spell synergy over bullet-hell memorization
- Boss encounters every few sublevels with unique elemental mechanics

### **Meta-Progression & Unlocks**

- Permanent upgrades between runs: new elements, spell modifiers, starting perks
- Unlock Light and Dark elements through special rift challenges
- Character variants with unique passive abilities
- Difficulty modifiers for veteran players seeking extra challenge

### **Performance-First Design**

- Built with Godot 4.4.1 using the Mobile renderer for maximum compatibility
- Sprite-based VFX only (no particle systems)—optimized for low-end hardware
- Modular VFX system: element effects layer and blend procedurally (no manual combo art)

---

## Gameplay Loop

1. **Choose 3 elements** at the start of your run
2. **Enter a TLA** (Fire, Water, Earth, or Wind arena)
3. **Clear rooms**: Fast-paced wave combat in procedurally generated arenas
4. **Loot between waves**: Chests, vendors, relics to modify your build
5. **Face bosses** every few sublevels for guaranteed high-tier rewards
6. **Optional rifts**: High-risk Light/Dark encounters for unique unlocks
7. **Descend deeper**: Infinite sublevels with scaling difficulty
8. **Die or extract**: Keep meta-progression currency to unlock permanent upgrades

---

## Element System

### **Base Elements**

- **Fire**: Energy state, tags: [hot, ignite, spread]
- **Water**: Liquid state, tags: [wet, flow, conduct]
- **Earth**: Solid state, tags: [heavy, slow, dense]
- **Wind**: Gas state, tags: [light, fast, push]
- **Light** (unlockable): Special state, tags: [pure, reveal, heal]
- **Dark** (unlockable): Special state, tags: [corrupt, drain, hide]

### **Combo Generation**

Combos are generated **dynamically** using rule-based tag matching:

- Hot + Wet → Steam
- Hot + Heavy → Lava
- Wet + Fast → Ice
- Ignite + Push → Wildfire
- Pure + Corrupt → Void (true damage)

Add new elements with unique tags → existing rules auto-generate new combos. No manual combo definitions required for most interactions.

### **Casting Mechanics**

- **Single element**: Instant cast, low damage, spammable
- **Double element**: 0.5-1s charge, medium damage, reduced movement speed
- **Triple element**: 1.5-2s charge, massive damage, high mana cost, movement locked

Higher element counts = higher risk, higher reward. Triple combos are tactical nukes.

---

## Getting Started

### **Requirements**

- Godot 4.4.1 or later
- Mobile renderer recommended for performance

### **Installation**

```bash
git clone git@github.com:XeonXE534/Aetherglass.git
cd Aetherglass
```

Open the project in Godot 4.4.1, select the **Mobile renderer**, and run the main scene.

---

## Development Status

**Current Phase**: Pre-Alpha / Prototype  
**Focus Areas**:

- Refining element combination system
- Balancing HP/mana costs and combat pacing
- Implementing procedural room generation
- Polishing dodge mechanics and spell casting feel

This is a learning project and experiment in emergent gameplay design. Expect frequent changes, rough edges, and half-implemented features.

---

## Contributing

Contributions, ideas, and feedback are welcome! This is an open-source learning project.

### **Areas Open for Contribution**

- New element types and interaction rules
- Enemy AI behaviors
- Procedural room layouts
- VFX sprite assets (modular base effects)
- Balance testing and feedback

---

## Technical Stack

- **Engine**: Godot 4.4.1 (Mobile renderer)
- **Language**: GDScript
- **Art Style**: 2D pixel art (some are placeholder assets currently)
- **Audio**: TBD

---

## Roadmap (Tentative)

- [ ] Core spell casting and combo system (in progress)
- [ ] Procedural arena generation with room stitching
- [ ] Enemy AI with elemental weaknesses/resistances
- [ ] Meta-progression and unlock system
- [ ] Light/Dark rift encounters
- [ ] Boss fights with unique mechanics
- [ ] Modular VFX system implementation
- [ ] Audio and SFX
- [ ] Playable demo release

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Contact

- **GitHub**: [XeonXE534](https://github.com/XeonXE534)
- **Project**: [Aetherglass Repository](https://github.com/XeonXE534/Aetherglass)

---

## Why "Aetherglass"?

The name reflects the game's core tension: **Aether** (magical energy/mana) and **Glass** (fragility). Your power and your survival are one and the same - every spell cast shatters a piece of your life force. Use it wisely.
