# AGENTS.md

This file defines repo-specific instructions for code generation in `TowerMiner`.

## Project Intent

`TowerMiner` is an iOS-first SwiftUI game. The target product is a portrait mining game with:

- Tile-based movement
- Procedural downward progression
- Hazards and collectible resources
- A run-to-upgrade gameplay loop
- Lightweight but polished visual feedback

Use [TowerMiner/TowerMiner/Plan.md](/Users/stevenmarshall/Documents/dev/ios/TowerMiner/TowerMiner/Plan.md) as the source of truth for implementation scope and sequencing.

## Current State

The current app still contains default Xcode template code:

- `ContentView.swift` is template list/navigation content
- `Item.swift` and SwiftData template wiring are still present
- Test targets are mostly placeholder stubs

When making gameplay changes, prefer replacing template app structure rather than extending the sample CRUD pattern.

## Primary Goal For Generated Code

Generated code should move the project toward a clean, testable game architecture that matches `Plan.md`, not toward a generic app shell or data-entry app.

## Platform and Product Constraints

- Primary device target: iPhone portrait
- Secondary target: iPad portrait with scaled layout
- Use SwiftUI as the UI layer
- Prefer simple, maintainable rendering over premature engine complexity
- Keep the MVP focused; do not add post-MVP systems unless explicitly requested

## Architecture Rules

### App Structure

- Keep app-level navigation simple and explicit
- Separate persistent profile data from active run state
- Avoid placing game rules directly inside SwiftUI view bodies
- Prefer dedicated models and systems for gameplay logic

### Recommended Organization

As features are added, prefer this structure:

- `TowerMiner/Models/`
- `TowerMiner/Systems/`
- `TowerMiner/Views/`
- `TowerMiner/Components/`
- `TowerMiner/Utilities/` only if clearly needed

Suggested responsibilities:

- `Models`: data structures such as tile state, player state, run result, upgrades
- `Systems`: procedural generation, game engine, persistence, balancing logic
- `Views`: screen-level SwiftUI views
- `Components`: reusable UI pieces such as HUD, controls, and tile rendering

### State Management

- Prefer SwiftUI-native observable state
- Keep a single source of truth for the active run
- Keep pure logic testable without depending on SwiftUI
- Avoid global mutable state

### Game Logic

- Game rules should be deterministic where practical
- Procedural generation should be encapsulated in a dedicated generator/system
- Movement, digging, hazards, and reward resolution should live in engine-like types, not views
- Use small, composable types instead of one large controller object

## Swift and SwiftUI Conventions

- Use `struct` by default for models unless reference semantics are clearly required
- Use `enum` for tile types, screens, actions, and state categories
- Prefer `let` over `var` wherever possible
- Avoid force unwraps
- Keep functions small and single-purpose
- Add brief comments only for non-obvious logic
- Use clear, game-oriented naming instead of generic names like `manager`, `handler`, or `data`

### View Rules

- Views should primarily render state and send user intent
- Avoid large monolithic views
- Extract reusable UI pieces once the screen structure is clear
- Keep layout readable and practical for portrait gameplay
- Prefer explicit styling and color choices over defaults

### Animation and Effects

- Keep effects lightweight and intentional
- Favor SwiftUI animation, transitions, overlays, and transforms before introducing heavier custom rendering
- Add polish only after the core interaction is functional

## Persistence Rules

- Do not assume SwiftData is the final persistence solution just because the template includes it
- For MVP profile persistence, prefer the simplest approach that fits the task
- If persistent gameplay profile data is needed, align with `Plan.md`
- Remove template persistence code when it stops serving the product

## Testing Rules

- Use the `Testing` framework for unit tests
- Use `XCUIAutomation` patterns for UI tests
- Add tests for gameplay rules when implementing logic-heavy systems
- Prioritize tests for:
  - procedural generation validity
  - movement and digging rules
  - hazard damage
  - reward payout
  - upgrade math

## Scope Control

- Default to MVP-only solutions
- Do not introduce networking, multiplayer, monetization, cloud sync, or analytics unless explicitly requested
- Do not add speculative abstractions for future biomes, enemies, or item systems before the core loop exists
- Do not over-engineer around extensibility at the cost of shipping the first playable version

## Migration Guidance

When replacing template code:

- Remove or rewrite template SwiftData CRUD patterns if they conflict with game architecture
- Rename generic template concepts to game-specific ones
- Keep each change coherent and buildable

## UI Direction

The game should feel intentional rather than template-like.

Prefer:

- Dark subterranean backgrounds
- Strong contrast for resources and hazards
- Clear HUD readability
- Bold, game-like controls sized for touch

Avoid:

- Plain form-based layouts
- Generic list-detail app structures
- Default placeholder visual styling once implementation begins

## Implementation Priority

Unless the user asks otherwise, prefer work in this order:

1. Replace template app shell with game-oriented navigation/state
2. Establish models for session, player, tiles, and upgrades
3. Implement grid rendering and player interaction
4. Add procedural generation and progression
5. Add results, persistence, and upgrades
6. Add polish, effects, and stronger test coverage

## Editing Discipline

- Limit changes to the requested task
- Preserve user-authored work
- Do not revert unrelated changes
- Keep files easy to scan
- Favor concrete implementations over placeholder comments when the user asks for working code

## When In Doubt

- Follow `Plan.md`
- Prefer simpler systems
- Keep gameplay logic out of views
- Choose buildable, testable code over ambitious abstractions
