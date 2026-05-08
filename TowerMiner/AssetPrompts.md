# Tower Miner Asset Prompts

Use this file to generate visual assets for `Tower Miner`.

## Global Style Direction

Use this style for every asset:

```text
Stylized mobile game art for Tower Miner, semi-pixel inspired but polished, dark underground fantasy mining theme, chunky readable shapes, crisp edges, subtle bevels, soft bloom, high contrast, modern iOS game quality, no watermark, no photorealism, no busy background.
```

## Main Workflow

ChatGPT image generation usually returns one image at a time. Generate one complete transparent asset sheet, then slice it into individual PNGs.

Sheet size:

- `3072x3072`
- `6 columns x 6 rows`
- Each normal cell is `512x512`
- Transparent background
- Thin white dashed square guide line around every `512x512` cell
- No labels, captions, filenames, size text, UI mockups, or background texture

When slicing:

- Cut on the white dashed guide lines.
- Remove guide lines from final sliced PNGs before importing into `Assets.xcassets`.
- Empty cells can be discarded.
- The logo spans one full row and should be sliced as one `3072x512` source image, then trimmed if needed.
- HUD panels can be sliced as `1024x512` images where marked.

## Single Asset Sheet Prompt

Paste this entire prompt into ChatGPT/image generation:

```text
Create one image only: tower_miner_asset_sheet.png.

Canvas and grid:
3072x3072 PNG.
Transparent background.
6 columns x 6 rows.
Each grid cell is exactly 512x512.
Add a thin WHITE dashed square guide line around every 512x512 cell.
The white dashed guide lines must be clearly visible on the transparent background.
Do not add any title labels, captions, filenames, size text, background texture, UI mockups, or extra decorative assets.

Style:
Stylized mobile game art for Tower Miner, semi-pixel inspired but polished, dark underground fantasy mining theme, chunky readable shapes, crisp edges, subtle bevels, soft bloom, high contrast, modern iOS game quality, no watermark, no photorealism.

Critical rules:
Every listed cell must be filled exactly as requested.
Do not duplicate cells.
Do not replace a requested asset with a different asset.
Do not omit the right arrow.
Do not omit the title logo.
All arrows must point in the requested direction.
The background behind every asset must remain transparent.
Only Row 3 column 2 may contain a standalone cyan diamond artwork.
Row 1 column 6 must be crystal veins embedded in rock, not a standalone diamond.
Row 4 column 3 must be star sparkles only, not a diamond.
The title logo may use small cyan glow accents, but no large diamond icon.
Only Row 6 columns 1-3 may contain the words TOWER MINER.
HUD panels must be blank frames with no letters, no words, and no logo.
Icons must look like their category, not like tiles.
Effects must look like loose particles or flashes, not solid blocks.
Empty cells must be empty except for the white dashed guide line.
Only Row 5 columns 1, 2, and 3 may contain navigation arrows.
No other asset may use an arrow shape.
Row 5 column 3 is the required right navigation button. It must be a white arrow pointing RIGHT, not a shield, not a gem, not a blank panel.

Anti-duplication rules:
Do not use a cyan gem for the player marker.
Do not use a cyan gem for the shield icon.
Do not use a cyan gem for the health icon.
Do not use a cyan gem for the energy icon.
Do not use a cyan gem for the HUD panels.
Do not reuse stone block art for icons.
Do not reuse dust effect art in more than one cell.
Do not repeat the title logo anywhere except Row 6 columns 1-3.
Do not repeat diamond silhouettes.
Do not repeat arrow silhouettes outside the three navigation buttons.
Do not put a shield icon in Row 5 column 3.
Do not put a gem icon in Row 5 column 3.
Do not put a blank panel in Row 5 column 3.

Grid order:

Row 1, column 1: empty dark mine shaft tile, mostly black interior, subtle stone edge frame, open void center.
Row 1, column 2: warm brown dirt block, earthy clay color, small rocks embedded, no metal.
Row 1, column 3: cool blue-gray stone block, clean cracked stone slabs, no gold, no gems.
Row 1, column 4: darker hard stone block, reinforced heavy rock, deeper blue-gray, stronger cracks, tougher than normal stone.
Row 1, column 5: gold ore block, gray stone with clearly visible bright gold nuggets embedded.
Row 1, column 6: cyan crystal vein ore block, gray stone block with thin glowing cyan cracks and small embedded crystal shards, no large diamond, still obviously a stone tile.

Row 2, column 1: treasure chest block, small wooden chest built into dirt and stone, cyan lock glow.
Row 2, column 2: lava hazard tile, molten orange-red lava pool, hot glow, no chest, no spikes.
Row 2, column 3: spike hazard tile, three sharp silver metal spikes rising from a dark stone base, no lava.
Row 2, column 4: compact miner character for a tile grid, above/front hybrid view, dark helmet, cyan headlamp glow, simple mining suit, chunky proportions.
Row 2, column 5: glowing player marker, circular cyan ring with a small dark miner helmet silhouette inside, no diamond, no gemstone.
Row 2, column 6: mining dust effect, warm brown dust puffs, small debris chips, radial burst, no duplicate dust elsewhere.

Row 3, column 1: bright gold coin icon, simple round shape, no rock block.
Row 3, column 2: standalone glowing cyan diamond crystal icon, faceted diamond silhouette, no rock block, no coin.
Row 3, column 3: dark iron bomb icon with small fuse spark.
Row 3, column 4: blue steel shield icon with cyan rim light, clearly shield-shaped, no diamond, no gemstone.
Row 3, column 5: red heart icon for health, clearly heart-shaped, no crystal, no gemstone.
Row 3, column 6: cyan lightning battery icon for energy, rectangular battery with lightning bolt, no diamond, no gemstone.

Row 4, column 1: depth gauge icon, vertical mine depth meter with tick marks and a small shaft symbol, no arrow shape, not a tile.
Row 4, column 2: stacked gold token icon for credits.
Row 4, column 3: cyan sparkle effect, star-shaped glints and small light particles, soft bloom, radial burst, no diamond silhouette.
Row 4, column 4: damage flash effect, red-orange hazard hit flash, small sharp shards.
Row 4, column 5: lava glow effect, orange-red heat shimmer, soft bloom edge, square tile compatible.
Row 4, column 6: empty transparent cell with only the white dashed guide line.

Row 5, column 1: LEFT NAVIGATION BUTTON, dark metal-and-stone rounded square, one large high-contrast white arrow pointing LEFT.
Row 5, column 2: DOWN NAVIGATION BUTTON, dark metal-and-stone rounded square, one large high-contrast white arrow pointing DOWN.
Row 5, column 3: RIGHT NAVIGATION BUTTON, dark metal-and-stone rounded square, one large high-contrast white arrow pointing RIGHT. The arrowhead must be on the RIGHT side and the tail must start on the LEFT side. This cell must not contain a shield, gem, panel, or blank button.
Row 5, column 4: bomb action button, dark metal-and-stone rounded square, centered bomb icon.
Row 5, column 5: empty transparent cell with only the white dashed guide line.
Row 5, column 6: empty transparent cell with only the white dashed guide line.

Row 6, columns 1-6 combined: title logo artwork containing only the readable words TOWER MINER. Chunky carved stone lettering, cyan glow accents, small cracks and mining scratches, centered horizontal logo composition, transparent background, no large diamond icon, no HUD panel, no blank rectangle, no extra object to the right of the logo. The logo should span the full row as one wide 3072x512 source asset.
```

## Slice Names

Use these names after slicing the sheet:

- Row 1 column 1: `tile_empty.png`
- Row 1 column 2: `tile_dirt.png`
- Row 1 column 3: `tile_stone.png`
- Row 1 column 4: `tile_hard_stone.png`
- Row 1 column 5: `tile_gold.png`
- Row 1 column 6: `tile_gem.png`
- Row 2 column 1: `tile_chest.png`
- Row 2 column 2: `tile_lava.png`
- Row 2 column 3: `tile_spike.png`
- Row 2 column 4: `player_miner.png`
- Row 2 column 5: `player_marker.png`
- Row 2 column 6: `fx_mining_dust.png`
- Row 3 column 1: `icon_coin.png`
- Row 3 column 2: `icon_gem.png`
- Row 3 column 3: `icon_bomb.png`
- Row 3 column 4: `icon_shield.png`
- Row 3 column 5: `icon_health.png`
- Row 3 column 6: `icon_energy.png`
- Row 4 column 1: `icon_depth.png`
- Row 4 column 2: `icon_credits.png`
- Row 4 column 3: `fx_gem_sparkle.png`
- Row 4 column 4: `fx_damage_flash.png`
- Row 4 column 5: `fx_lava_glow.png`
- Row 5 column 1: `button_left.png`
- Row 5 column 2: `button_down.png`
- Row 5 column 3: `button_right.png`
- Row 5 column 4: `button_bomb.png`
- Row 6 columns 1-6: `title_logo.png`

## HUD Panel Fallback Prompt

Generate HUD panels separately if needed. Keeping panels separate prevents the image model from attaching them to the title logo.

```text
Create one transparent PNG named panel_hud.png.

Canvas:
1024x512 PNG.
Transparent background.
No dashed guide lines.
No title text, labels, captions, filenames, logo, or words.

Asset:
One wide horizontal HUD panel frame for Tower Miner. Dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlights, blank center, polished semi-pixel mobile game style.
```

```text
Create one transparent PNG named panel_stat_chip.png.

Canvas:
512x512 PNG.
Transparent background.
No dashed guide lines.
No title text, labels, captions, filenames, logo, or words.

Asset:
One compact stat chip panel for Tower Miner. Dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlights, blank center, polished semi-pixel mobile game style.
```

## Background Prompts

Generate backgrounds separately because they are opaque full-screen images, not transparent sheet assets.

### Menu Background

```text
Create one opaque portrait PNG named bg_menu.png. Portrait mobile game menu background for Tower Miner. Dark underground mine shaft, subtle stacked stone blocks, faint cyan gem glow near center, warm lava glow near bottom edge, high contrast but not busy, enough negative space for title and buttons, polished semi-pixel mobile game style, no text.
```

### Run Background

```text
Create one opaque portrait PNG named bg_run.png. Portrait gameplay background for Tower Miner. Dark vertical mine shaft atmosphere, subtle stone grid, deep black center area for gameplay board, faint blue-gray rock texture, sparse cyan gem reflections, warm lava glow at bottom, polished semi-pixel mobile game style, not busy, no text.
```

### Results Screen Background

```text
Create one opaque portrait PNG named bg_results.png. Portrait results screen background for Tower Miner. Dark mine chamber with a small pile of coins and glowing gems at the bottom, soft cyan and gold highlights, subdued center area for UI panels, polished semi-pixel mobile game style, no text.
```
