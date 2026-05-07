# Tower Miner - Full Implementation Plan

## Goal

Build a polished MVP of `Tower Miner` as an iOS-first SwiftUI game where the player mines downward through an endless shaft, collects resources, avoids hazards, and spends persistent currency on upgrades between runs.

The first release should prioritize:

- Tight controls
- Readable game state
- Reliable procedural generation
- A clean run-to-upgrade loop
- A visual style that is simple to produce but still distinct

This plan assumes the current project is a basic SwiftUI app and needs game structure, systems, UI, and tests added from scratch.

---

## Progress Tracking

Use the checkboxes in the milestone, task, testing, and MVP sections below as the live source of implementation status.

Current overall status:

- [x] Milestone 1: App Shell
- [x] Milestone 2: Core Grid Gameplay
- [ ] Milestone 3: Procedural Generation and Difficulty
- [ ] Milestone 4: Health, Energy, and Hazards
- [ ] Milestone 5: Rewards and Upgrades
- [ ] Milestone 6: Polish Pass
- [ ] MVP complete

---

## Product Definition

### Core Fantasy

The player is trapped in a shifting underground tower and must dig deeper for better rewards while managing health, energy, and limited consumables.

### MVP Success Criteria

The MVP is complete when the player can:

1. Start a run from a menu
2. Move and dig through a scrolling mine grid
3. Collect gems and coins
4. Take damage from hazards
5. Use at least one consumable ability
6. End a run by dying or quitting
7. Return to a hub/results screen
8. Spend currency on permanent upgrades
9. Start another run with improved stats

---

## Target Platform

### Primary

- iPhone portrait

### Secondary

- iPad portrait with scaled layout

### Deferred

- Landscape support
- Game Center
- Cloud sync
- Audio settings
- Haptics customization

---

## MVP Scope

### Included

- Single-player endless mining run
- Procedural row generation
- Tile-based movement and digging
- Hazards and resource pickups
- Basic persistent upgrades
- Lightweight particles and screen shake
- Results summary after each run

### Excluded From MVP

- Story mode
- Multiple biomes
- Enemies with AI pathing
- Equipment loadouts
- Daily challenges
- Leaderboards
- Crafting
- Ads or monetization

---

## Gameplay Loop

1. Player launches app and lands on a home screen.
2. Player views current permanent upgrades and total currency.
3. Player starts a mining run.
4. Mine rows generate as the player moves downward.
5. Player digs, collects loot, avoids hazards, and manages health and energy.
6. Difficulty increases with depth through harder blocks and denser hazards.
7. Run ends on death or manual exit.
8. Results screen shows depth, loot, and earned currency.
9. Currency is added to persistent profile.
10. Player spends currency on upgrades and starts again.

---

## Game Rules

### Player Actions

- Move left or right into empty tiles
- Move down into empty tiles
- Dig adjacent diggable tiles
- Use bomb to clear a small area
- Use shield to absorb temporary damage

### Failure Conditions

- Health reaches zero
- Optional later rule: player is crushed or trapped

### Progression Conditions

- Deeper depth increases score value and resource rarity
- Coins and gems convert into persistent currency at run end

### Resource Model

- `Health`: damage buffer
- `Energy`: consumed by digging and abilities
- `Coins`: common currency collected during a run
- `Gems`: premium run resource with higher conversion value
- `Bombs`: consumable area-clear ability
- `Shields`: consumable defensive ability

---

## Core Systems

### 1. Game State System

Create a central game state object to manage:

- Current screen
- Active run data
- Persistent player profile
- Pause/resume flow
- Run result summary

Recommended structure:

- `AppScreen`
- `GameSession`
- `PlayerProfile`
- `RunResult`
- `UpgradeCatalog`

Implementation notes:

- Use an `@Observable` or equivalent SwiftUI-friendly model
- Keep persistent data separate from active run state
- Avoid putting procedural generation directly inside views

### 2. Grid and Tile System

Represent the mine as a 2D grid with a fixed visible width and dynamically maintained vertical depth.

Recommended MVP values:

- `columns = 9`
- Visible rows sized to device height
- Maintain a buffered set of rows above and below the player

Tile model should include:

- Tile type
- Durability
- Reward payload if any
- Hazard flag
- Visual variant seed

Suggested tile types:

- `empty`
- `dirt`
- `stone`
- `hardStone`
- `gem`
- `gold`
- `lava`
- `spike`
- `cracked`
- `chest`

### 3. Procedural Generation System

Generate rows deterministically from:

- Current depth
- Random seed
- Difficulty curve rules

Generation requirements:

- Ensure the opening area is safe
- Avoid fully blocking progress
- Scale density of hard blocks and hazards with depth
- Increase gem and chest rarity gradually
- Guarantee occasional recovery opportunities

Implementation approach:

1. Define row-generation weights by depth band.
2. Generate candidate tiles for each column.
3. Validate for playability.
4. Regenerate row if it fails simple constraints.

Simple playability rules for MVP:

- At least one reachable dig path downward
- No impossible hazard wall spanning full width
- No unavoidable damage at spawn

### 4. Movement and Digging System

Movement should be turn-like in logic but feel real-time in presentation.

Rules:

- Horizontal move allowed into `empty`
- Down move allowed into `empty`
- Dig action targets adjacent diggable tile
- Digging reduces tile durability
- Destroyed tile becomes `empty`
- Gravity effect moves player downward if unsupported

Polish behaviors:

- Short animation on movement
- Hit flash or crack stage on damaged tiles
- Dust particles on successful dig

### 5. Hazard System

Start with simple hazards:

- `lava`: immediate damage on contact
- `spike`: damage on entry
- `cracked`: breaks after interaction or delay

Hazard rules:

- Damage should be readable and avoid feeling unfair
- Early depth should introduce hazards gradually
- Hazard tiles need a strong visual signature

### 6. Loot and Economy System

Run pickups:

- Coins
- Gems
- Chests

Persistent economy:

- Convert run rewards into total profile currency
- Use one main spendable currency for MVP to keep economy simple

Recommendation:

- Convert coins and gems into `credits`
- Store run stats separately for presentation

### 7. Upgrade System

Permanent upgrades should modify future runs.

Initial upgrade list:

- Max health
- Max energy
- Dig power
- Starting bombs
- Starting shields
- Gem value multiplier

Upgrade data needs:

- Identifier
- Name
- Description
- Current level
- Max level
- Cost formula
- Effect formula

### 8. UI and HUD System

Required screens:

- Home screen
- Active run screen
- Pause overlay
- Results screen
- Upgrade shop screen

HUD elements during run:

- Health bar
- Energy bar
- Depth counter
- Coins count
- Gems count
- Bomb count
- Shield count

### 9. Persistence System

Persist:

- Total currency
- Upgrade levels
- Best depth
- Last selected settings if any

MVP storage choice:

- `UserDefaults` for profile and upgrades

Future migration option:

- SwiftData if profile complexity grows

### 10. Effects and Feedback System

MVP feedback package:

- Screen shake on bomb use and heavy damage
- Glow styling for gems and lava
- Dust particles on mining
- Sparkle effect for rare loot
- Damage flash overlay

Keep implementation lightweight:

- SwiftUI animations for shake/flash
- Small particle layer or repeated animated shapes
- Avoid overbuilding a custom rendering engine for MVP

---

## UI Architecture

### Home Screen

Shows:

- Game title
- Start run button
- Best depth
- Total currency
- Shortcut to upgrades

### Run Screen

Contains:

- Scrolling mine playfield
- HUD
- On-screen controls
- Pause button

### Results Screen

Shows:

- Final depth
- Coins collected
- Gems collected
- Total payout
- New best depth if achieved
- Buttons for retry and upgrades

### Upgrade Screen

Shows:

- Current currency
- Upgrade cards or rows
- Cost and current level
- Purchase button state

---

## Technical Architecture

### Suggested File Structure

Recommended project organization:

- `Models/`
- `Systems/`
- `Views/`
- `ViewModels/` or feature state containers if needed
- `Components/`
- `Resources/`

Suggested initial files:

- `Models/Tile.swift`
- `Models/PlayerState.swift`
- `Models/GameSession.swift`
- `Models/PlayerProfile.swift`
- `Models/Upgrade.swift`
- `Systems/MineGenerator.swift`
- `Systems/GameEngine.swift`
- `Systems/ProfileStore.swift`
- `Views/HomeView.swift`
- `Views/GameView.swift`
- `Views/ResultsView.swift`
- `Views/UpgradeView.swift`
- `Components/GameHUD.swift`
- `Components/ControlPad.swift`
- `Components/MineTileView.swift`

### State Ownership

- App-level state owns navigation and persistent profile
- Run-level state owns grid, player stats, and active effects
- Views render state and send intents

### Data Flow

1. App starts and loads persistent profile.
2. User starts run.
3. New `GameSession` is created using profile upgrades.
4. `GameEngine` mutates session in response to player input.
5. UI observes session changes and animates.
6. Run ends and converts to `RunResult`.
7. `ProfileStore` saves updated profile.

---

## Art and Visual Plan

### Style Direction

Aim for stylized pixel-inspired blocks with modern overlays, not strict retro purity.

### Practical MVP Art Approach

- Use simple geometric tile rendering in SwiftUI first
- Add gradients, shadows, and glow overlays
- Replace with hand-authored assets later if needed

### Color Direction

- Background: deep navy, charcoal, muted violet accents
- Dirt: warm brown
- Stone: cool blue-gray
- Gems: cyan, emerald, ruby
- Lava: orange-red with bloom-like glow
- UI: dark translucent panels with high-contrast counters

### Asset Plan

Phase 1:

- Build visuals entirely in SwiftUI shapes and colors

Phase 2:

- Add custom icons for bomb, shield, gem, coin
- Add title art and splash polish

---

## Control Plan

### iPhone Controls

- Left button
- Right button
- Down/dig button
- Bomb button
- Shield button

Control requirements:

- Thumb reachable in portrait
- Large tap targets
- Clear cooldown/availability states

### Input Behavior

- Tap buttons for deliberate movement
- Hold-to-repeat can be added later
- Avoid swipe controls in MVP unless button controls feel poor

---

## Balancing Plan

### Starting Stats

Recommended initial values:

- Health: `5`
- Energy: `10`
- Bombs: `1`
- Shields: `1`
- Dig power: `1`

### Early Difficulty Curve

- Depth 0-20: mostly dirt and stone, minimal hazards
- Depth 21-50: introduce spikes and cracked blocks
- Depth 51+: add lava pockets and more hard stone

### Reward Curve

- Common resources should appear every few rows
- Rare rewards should create spikes of excitement
- Upgrade costs should support meaningful progress every 1-3 runs early on

---

## Milestone Plan

### Milestone 1: App Shell

Deliverables:

- [x] App navigation structure
- [x] Home screen
- [x] Placeholder run screen
- [x] Persistent profile model

Definition of done:

- [x] App launches into a usable menu
- [x] Start button creates a new session

### Milestone 2: Core Grid Gameplay

Deliverables:

- [x] Tile model
- [x] Visible mine grid
- [x] Player position
- [x] Left/right/down movement
- [x] Basic digging

Definition of done:

- [x] Player can move and clear blocks in a generated shaft

### Milestone 3: Procedural Generation and Difficulty

Deliverables:

- [ ] Row generation rules
- [ ] Depth progression
- [ ] Harder blocks and hazard placement

Definition of done:

- [ ] Runs feel variable and remain playable over depth

### Milestone 4: Health, Energy, and Hazards

Deliverables:

- [ ] Damage system
- [ ] Hazard tile interactions
- [ ] Run over condition

Definition of done:

- [ ] Player can lose a run through understandable mistakes

### Milestone 5: Rewards and Upgrades

Deliverables:

- [ ] Coins/gems collection
- [ ] Results screen
- [ ] Currency payout
- [ ] Upgrade purchases

Definition of done:

- [ ] Full replay loop is functional

### Milestone 6: Polish Pass

Deliverables:

- [ ] Animations
- [ ] Particles
- [ ] Screen shake
- [ ] Better HUD styling
- [ ] iPad layout adjustments

Definition of done:

- [ ] Game feels coherent and visually intentional

---

## Task Breakdown

### Phase 1: Foundation

- [x] Create app-level screen routing.
- [x] Define persistent profile and upgrade models.
- [x] Add storage layer for profile save/load.
- [x] Build menu and upgrade screens with placeholder content.

### Phase 2: Playfield

- [x] Define tile, coordinate, and player state models.
- [x] Implement mine grid storage.
- [x] Implement visible grid rendering.
- [x] Add player avatar rendering and camera offset logic.

### Phase 3: Engine

- [x] Implement move validation.
- [x] Implement dig resolution.
- [x] Implement gravity/drop behavior.
- [ ] Implement row generation and row trimming.
- [ ] Add depth tracking.

### Phase 4: Systems

- [ ] Add pickups and inventory changes.
- [ ] Add hazard interactions and damage.
- [ ] Add bombs and shields.
- [ ] Add run-end logic and summary conversion.

### Phase 5: Progression

- [ ] Add upgrade purchase flow.
- [ ] Apply upgrade modifiers to new sessions.
- [ ] Add best-depth tracking.
- [ ] Tune economy values.

### Phase 6: Polish

- [ ] Improve visual identity.
- [ ] Add particles and flashes.
- [ ] Add screen shake and stronger feedback.
- [ ] Tune layouts for small and large devices.

---

## Testing Plan

### Unit Tests

Add tests for:

- [ ] Row generation validity
- [ ] Upgrade cost calculations
- [ ] Reward payout calculations
- [ ] Movement and dig rules
- [ ] Hazard damage rules

### UI Tests

Add tests for:

- [ ] Launch to home screen
- [ ] Start run flow
- [ ] Open upgrades flow
- [ ] Buy upgrade if currency is available
- [ ] End run and return to menu

### Manual Test Checklist

- [ ] Start multiple runs and verify generation variability
- [ ] Verify no immediate impossible spawn states
- [ ] Verify health and energy update correctly
- [ ] Verify rewards persist after app relaunch
- [ ] Verify upgrade effects apply to next run
- [ ] Verify controls remain usable on small iPhones
- [ ] Verify layout scales correctly on iPad

---

## Risks and Mitigations

### Risk: Procedural Generation Creates Unfair States

Mitigation:

- Keep rules simple
- Add validation checks
- Bias early rows toward safety

### Risk: SwiftUI Grid Rendering Becomes Janky

Mitigation:

- Keep visible row count limited
- Render only nearby tiles
- Avoid unnecessary view recomputation

### Risk: Too Many Systems Added Too Early

Mitigation:

- Finish the basic run loop before adding extra hazards or mechanics
- Keep MVP economy to one persistent spend currency

### Risk: Visual Direction Feels Generic

Mitigation:

- Define color language early
- Use glow, contrast, and motion intentionally
- Delay asset production until gameplay is solid

---

## Post-MVP Expansion Options

- Biomes with unique tile tables
- Enemy creatures
- Drill or rope tools
- Combo scoring
- Daily seed challenge
- Meta progression tree
- Better audio and haptics
- Accessibility options

---

## Recommended Build Order

- [x] Home screen and app state
- [x] Game session model
- [x] Tile grid and rendering
- [x] Movement and digging
- [ ] Procedural generation
- [ ] Health, hazards, and run end
- [ ] Rewards and results
- [ ] Persistent upgrades
- [ ] Effects and polish
- [ ] Tests and balancing

---

## Definition of MVP Complete

The MVP is complete when:

- [ ] The game can be launched and played end to end without placeholder blockers
- [ ] A full run can start, progress, end, and convert into persistent rewards
- [ ] Upgrades can be purchased and affect later runs
- [ ] Core controls feel responsive on iPhone
- [ ] The project has basic automated coverage for core rules
- [ ] The visual presentation is simple but polished enough to feel intentional
