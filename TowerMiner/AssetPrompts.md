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
- The logo spans three cells and should be sliced as one `1536x512` image.
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

Grid order:

Row 1, column 1: empty dark mine shaft tile, mostly black interior, subtle stone edge frame, open void center.
Row 1, column 2: warm brown dirt block, earthy clay color, small rocks embedded, no metal.
Row 1, column 3: cool blue-gray stone block, clean cracked stone slabs, no gold, no gems.
Row 1, column 4: darker hard stone block, reinforced heavy rock, deeper blue-gray, stronger cracks, tougher than normal stone.
Row 1, column 5: gold ore block, gray stone with clearly visible bright gold nuggets embedded.
Row 1, column 6: cyan gem ore block, gray stone with clearly visible glowing cyan crystal embedded.

Row 2, column 1: treasure chest block, small wooden chest built into dirt and stone, cyan lock glow.
Row 2, column 2: lava hazard tile, molten orange-red lava pool, hot glow, no chest, no spikes.
Row 2, column 3: spike hazard tile, three sharp silver metal spikes rising from a dark stone base, no lava.
Row 2, column 4: compact miner character for a tile grid, above/front hybrid view, dark helmet, cyan headlamp glow, simple mining suit, chunky proportions.
Row 2, column 5: glowing player marker, cyan circular core with white highlight, small helmet silhouette inside, soft bloom.
Row 2, column 6: mining dust effect, warm brown dust puffs, small debris chips, radial burst.

Row 3, column 1: bright gold coin icon, simple round shape, no rock block.
Row 3, column 2: glowing cyan diamond crystal icon, no coin.
Row 3, column 3: dark iron bomb icon with small fuse spark.
Row 3, column 4: blue steel shield icon with cyan rim light.
Row 3, column 5: red heart or red health crystal icon.
Row 3, column 6: cyan lightning battery icon for energy.

Row 4, column 1: downward arrow icon into a mine shaft for depth.
Row 4, column 2: stacked gold token icon for credits.
Row 4, column 3: gem sparkle effect, cyan sparkles, diamond glints, soft bloom, radial burst.
Row 4, column 4: damage flash effect, red-orange hazard hit flash, small sharp shards.
Row 4, column 5: lava glow effect, orange-red heat shimmer, soft bloom edge, square tile compatible.
Row 4, column 6: empty transparent cell with only the white dashed guide line.

Row 5, column 1: left arrow control button, dark metal-and-stone rounded square, high-contrast white arrow pointing LEFT.
Row 5, column 2: down arrow control button, dark metal-and-stone rounded square, high-contrast white arrow pointing DOWN.
Row 5, column 3: right arrow control button, dark metal-and-stone rounded square, high-contrast white arrow pointing RIGHT. The arrowhead must be on the RIGHT side. Do not make another left arrow.
Row 5, column 4: bomb action button, dark metal-and-stone rounded square, centered bomb icon.
Row 5, column 5: shield action button, dark metal-and-stone rounded square, centered shield icon.
Row 5, column 6: empty transparent cell with only the white dashed guide line.

Row 6, columns 1-3 combined: title logo artwork containing the readable words TOWER MINER. Chunky carved stone lettering, cyan gem glow accents, small cracks and mining scratches, horizontal logo composition, transparent background. The logo should span columns 1, 2, and 3 as one wide 1536x512 asset.
Row 6, columns 4-5 combined: wide horizontal HUD panel frame, dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlights, no text. This panel should span columns 4 and 5 as one 1024x512 asset.
Row 6, column 6: compact stat chip panel, dark translucent mining cockpit style, cyan rim highlight, no text.
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
- Row 5 column 5: `button_shield.png`
- Row 6 columns 1-3: `title_logo.png`
- Row 6 columns 4-5: `panel_hud.png`
- Row 6 column 6: `panel_stat_chip.png`

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
