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
- [x] Milestone 3: Procedural Generation and Difficulty
- [x] Milestone 4: Health, Energy, and Hazards
- [x] Milestone 5: Rewards and Upgrades
- [x] Milestone 6: Polish Pass
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

- [x] Row generation rules
- [x] Depth progression
- [x] Harder blocks and hazard placement

Definition of done:

- [x] Runs feel variable and remain playable over depth

### Milestone 4: Health, Energy, and Hazards

Deliverables:

- [x] Damage system
- [x] Hazard tile interactions
- [x] Run over condition

Definition of done:

- [x] Player can lose a run through understandable mistakes

### Milestone 5: Rewards and Upgrades

Deliverables:

- [x] Coins/gems collection
- [x] Results screen
- [x] Currency payout
- [x] Upgrade purchases

Definition of done:

- [x] Full replay loop is functional

### Milestone 6: Polish Pass

Deliverables:

- [x] Animations
- [x] Particles
- [x] Screen shake
- [x] Better HUD styling
- [x] iPad layout adjustments

Definition of done:

- [x] Game feels coherent and visually intentional

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
- [x] Implement row generation and row buffering.
- [x] Add depth tracking.

### Phase 4: Systems

- [x] Add pickups and inventory changes.
- [x] Add hazard interactions and damage.
- [x] Add bombs.
- [x] Add shields.
- [x] Add run-end logic.
- [x] Add summary conversion.

### Phase 5: Progression

- [x] Add upgrade purchase flow.
- [x] Apply upgrade modifiers to new sessions.
- [x] Add best-depth tracking.
- [x] Tune economy values.

### Phase 6: Polish

- [x] Improve visual identity.
- [x] Add particles and flashes.
- [x] Add screen shake and stronger feedback.
- [x] Tune layouts for small and large devices.

---

## Testing Plan

### Unit Tests

Add tests for:

- [x] Row generation validity
- [x] Upgrade cost calculations
- [x] Reward payout calculations
- [x] Movement and dig rules
- [x] Hazard damage rules

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
- [x] Verify health and energy update correctly
- [x] Verify rewards persist after app relaunch
- [x] Verify upgrade effects apply to next run
- [x] Verify controls remain usable on small iPhones
- [x] Verify layout scales correctly on iPad

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

Use this section to choose feature groups for future versions after the MVP is complete. Each option should be implemented as a coherent release slice rather than partially scattered across unrelated versions.

### 1. Better Audio and Haptics

Goal:

- Make existing actions feel more responsive and polished without changing core rules.

Version fit:

- Best for an early post-MVP quality release.

Implementation checklist:

- [x] Add an `AudioFeedbackSystem` for short gameplay sounds.
- [x] Add a `HapticFeedbackSystem` with small, medium, and warning feedback events.
- [x] Trigger feedback for mining, failed dig, movement, coin pickup, gem pickup, damage, bomb use, shield use, run over, and upgrade purchase.
- [x] Add user settings for sound enabled and haptics enabled.
- [x] Persist feedback settings in the profile or settings store.
- [x] Keep feedback calls out of SwiftUI view bodies where practical by routing through game actions or session events.
- [ ] Tune volume and haptic intensity so repeated digging does not feel noisy or tiring.

Testing checklist:

- [x] Verify settings persist after app relaunch.
- [ ] Verify disabled sound and haptics do not fire during gameplay.
- [ ] Manually test repeated mining and pickup feedback on device.

### 2. Accessibility Options

Goal:

- Make the game easier to read and control across more players and devices.

Version fit:

- Best for an early post-MVP quality release, especially once real users are playing.

Implementation checklist:

- [ ] Add a settings screen or settings panel reachable from the home and pause screens.
- [ ] Add reduced motion mode that disables or softens screen shake and intense transitions.
- [ ] Add larger controls mode for bigger touch targets.
- [ ] Add high-contrast tile and HUD styling.
- [ ] Add optional hold-to-repeat for movement and digging.
- [ ] Ensure all controls have useful accessibility labels.
- [ ] Review text scaling so HUD counters and buttons remain readable without overlapping.
- [ ] Persist accessibility settings.

Testing checklist:

- [ ] Verify reduced motion disables screen shake.
- [ ] Verify larger controls remain usable on small iPhones.
- [ ] Verify high-contrast mode keeps hazards and resources visually distinct.
- [ ] Verify VoiceOver names core buttons clearly.

### 3. Daily Seed Challenge

Goal:

- Add a lightweight reason to replay by giving every player the same daily mine layout.

Version fit:

- Good for a retention-focused release after the core loop feels stable.

Implementation checklist:

- [ ] Add a `DailyChallenge` model with date, seed, run rules, and best local result.
- [ ] Add deterministic seed generation based on local calendar date.
- [ ] Add a daily challenge entry point on the home screen.
- [ ] Start challenge runs from the daily seed instead of a random seed.
- [ ] Keep challenge results separate from normal best-depth stats.
- [ ] Decide whether upgrades apply to daily challenges or whether daily runs use fixed stats.
- [ ] Add a daily results presentation showing depth, payout, and local best for the day.
- [ ] Persist current-day best result and recent challenge history.

Testing checklist:

- [ ] Verify the same date produces the same seed.
- [ ] Verify different dates produce different seeds.
- [ ] Verify challenge runs do not overwrite normal run records incorrectly.
- [ ] Manually verify the daily challenge resets on the next calendar day.

### 4. Biomes With Unique Tile Tables

Goal:

- Increase variety by changing visuals, tile weights, hazards, and rewards by depth band.

Version fit:

- Strong candidate for the first larger content release.

Implementation checklist:

- [ ] Add a `Biome` model with identifier, name, depth range, color palette, tile weights, reward tuning, and hazard tuning.
- [ ] Update `MineGenerator` to select generation rules from the active biome.
- [ ] Add at least two post-MVP biomes after the starting dirt cave.
- [ ] Add visual treatment for biome transitions.
- [ ] Add biome-specific tile variants or overlays where needed.
- [ ] Ensure each biome still guarantees a playable downward path.
- [ ] Add biome names or subtle transition banners in the run UI.
- [ ] Tune reward and hazard curves so later biomes feel harder but fair.

Testing checklist:

- [ ] Add generation validity tests for each biome.
- [ ] Verify biome transitions happen at expected depths.
- [ ] Verify each biome can generate many rows without fully blocking progress.
- [ ] Manually test readability of each biome on phone and iPad.

### 5. Drill or Rope Tools

Goal:

- Add new consumable tools that create tactical choices without requiring enemy AI or large systems.

Version fit:

- Good for a mechanics-focused release after upgrades and economy are stable.

Implementation checklist:

- [ ] Add a `ToolType` or extend consumable inventory to support drill and rope.
- [ ] Define drill behavior, such as clearing a short line downward or breaking hard blocks more efficiently.
- [ ] Define rope behavior, such as recovering from a fall, escaping upward, or returning to a safer row.
- [ ] Add tool counts to `PlayerState`.
- [ ] Add tool buttons or a compact tool selector to the run controls.
- [ ] Add upgrade hooks for starting tool count or tool effectiveness.
- [ ] Add clear visual and feedback effects for each tool.
- [ ] Update results and profile data if tools affect rewards or progression.

Testing checklist:

- [ ] Add unit tests for drill tile-clearing rules.
- [ ] Add unit tests for rope positioning and invalid-use rules.
- [ ] Verify tool counts decrement only on successful use.
- [ ] Manually test controls for accidental taps and cramped layouts.

### 6. Combo Scoring

Goal:

- Reward skillful play and create score-chasing goals beyond raw depth.

Version fit:

- Good after players understand the base loop and need higher-skill incentives.

Implementation checklist:

- [ ] Add combo state to the active run, including current combo, best combo, and timeout or break rules.
- [ ] Define combo triggers, such as consecutive gem pickups, fast digs, no-damage streaks, or continuous downward movement.
- [ ] Define combo breakers, such as taking damage, idling too long, or using certain tools.
- [ ] Add score or bonus payout formulas tied to combo tiers.
- [ ] Add compact HUD feedback for active combo state.
- [ ] Add results screen stats for best combo and combo bonus earned.
- [ ] Tune combo values so they reward skill without becoming mandatory for progression.

Testing checklist:

- [ ] Add unit tests for combo start, increment, break, and payout.
- [ ] Verify combo bonuses are included in run result conversion.
- [ ] Manually verify HUD feedback is readable during active play.

### 7. Meta Progression Tree

Goal:

- Expand permanent progression beyond a flat upgrade list while preserving a clear economy.

Version fit:

- Best for a larger progression release after upgrade balance is validated.

Implementation checklist:

- [ ] Define progression branches, such as survival, mining, economy, and tools.
- [ ] Add a `ProgressionNode` model with prerequisites, cost, level, and effect.
- [ ] Decide whether this replaces the current upgrade list or layers on top of it.
- [ ] Add profile persistence for unlocked nodes and node levels.
- [ ] Add a progression tree screen with clear locked, available, purchased, and maxed states.
- [ ] Apply node effects when creating a new `GameSession`.
- [ ] Add respec support only if balance changes require it.
- [ ] Keep early nodes cheap enough to support meaningful progress every few runs.

Testing checklist:

- [ ] Add tests for prerequisite validation.
- [ ] Add tests for node cost and effect formulas.
- [ ] Verify profile migration from current upgrade data.
- [ ] Manually test that the tree remains readable on iPhone portrait.

### 8. Enemy Creatures

Goal:

- Add dynamic threats that make the mine feel more alive and increase decision pressure.

Version fit:

- Save for a later content release because it has the highest complexity and balance risk.

Implementation checklist:

- [ ] Add an `Enemy` model with position, type, health, behavior, and damage.
- [ ] Add enemy occupancy rules to prevent impossible or unreadable tile states.
- [ ] Define simple enemy types first, such as stationary nest, horizontal crawler, or falling hazard creature.
- [ ] Add turn/update rules that integrate with player movement and gravity.
- [ ] Add spawn rules to `MineGenerator` with depth-based limits.
- [ ] Add collision and damage rules between player, enemies, tools, bombs, and hazards.
- [ ] Add enemy rendering and clear danger telegraphs.
- [ ] Add reward drops only if they improve the loop without encouraging farming.
- [ ] Tune spawn density so enemies add pressure without blocking progression unfairly.

Testing checklist:

- [ ] Add unit tests for enemy movement and collision rules.
- [ ] Add generation tests to prevent unfair enemy spawn states.
- [ ] Verify enemies cannot trap the player immediately after spawn.
- [ ] Manually test readability during crowded board states.

### 9. Career Stats and New Best Callout

Goal:

- Give players a quick sense of long-term progress and make personal-best runs feel more rewarding.

Version fit:

- Small quality-of-life item that fits an early polish release.

Implementation checklist:

- [x] Add lifetime run count, credits earned, coins collected, and gems collected to `PlayerProfile`.
- [x] Update profile result application to increment career totals after each run.
- [x] Preserve older saves by decoding missing career fields with sensible defaults.
- [x] Add a compact career stats panel to the home screen.
- [x] Add a new-best-depth callout on the results screen.
- [x] Keep large values compact and single-line in career stat UI.

Testing checklist:

- [x] Add unit coverage for career total updates after a run.
- [x] Add unit coverage for legacy profile decoding defaults.
- [x] Run the unit test suite.
- [ ] Manually verify the home stats and new-best callout on device.

---

## Recommended Build Order

- [x] Home screen and app state
- [x] Game session model
- [x] Tile grid and rendering
- [x] Movement and digging
- [x] Procedural generation
- [x] Health, hazards, and run end
- [x] Rewards and results
- [x] Persistent upgrades
- [x] Effects and polish
- [x] Tests and balancing

---

## Definition of MVP Complete

The MVP is complete when:

- [ ] The game can be launched and played end to end without placeholder blockers
- [x] A full run can start, progress, end, and convert into persistent rewards
- [x] Upgrades can be purchased and affect later runs
- [x] Core controls feel responsive on iPhone
- [x] The project has basic automated coverage for core rules
- [x] The visual presentation is simple but polished enough to feel intentional
