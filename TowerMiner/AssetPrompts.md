# Tower Miner Asset Prompts

Use this prompt to generate one consistent asset sheet, then slice it into individual PNG files for `Assets.xcassets`.

## Asset Sheet Prompt

Paste this into ChatGPT/image generation:

```text
Create one image only: tower_miner_asset_sheet.png.

Canvas:
Square image.
Transparent background.
6 columns x 6 rows.
Every cell must be the same size.
Add a small transparent gutter between every cell so the red borders are not touching side by side.
Add a thin solid RED square border around every cell so each asset can be cut out consistently.
The red borders must be clearly visible.
Do not add labels, captions, filenames, size text, UI mockups, background texture, or decorative filler.

Style:
Stylized mobile game art for Tower Miner, semi-pixel inspired but polished, dark underground fantasy mining theme, chunky readable shapes, crisp edges, subtle bevels, soft bloom, high contrast, modern iOS game quality, no watermark, no photorealism.

Global rules:
Every cell must contain exactly one requested asset unless marked empty.
Keep each asset centered inside its red-bordered cell.
Leave consistent padding inside every cell.
Leave consistent transparent spacing outside every red border so each bordered asset is visually separated from neighboring cells.
Do not place objects outside the red borders.
Do not duplicate cells.
Do not add logos or text except in the title logo cell.
Do not add background scenes inside sprite/icon/button cells.
Empty cells should contain only the red border and transparent interior.

Grid order:

Row 1, column 1: tile_empty.png - empty dark mine shaft tile, mostly black interior, subtle blue-gray stone edge frame, open void center.
Row 1, column 2: tile_dirt.png - warm brown dirt block tile, earthy clay color, small embedded rocks, rough cracked surface, no metal, no gems, no gold.
Row 1, column 3: tile_stone.png - cool blue-gray stone block tile, clean cracked stone slabs, no gold, no gems, no dirt, no lava.
Row 1, column 4: tile_hard_stone.png - darker hard stone block tile, reinforced heavy rock, deeper blue-gray color, stronger cracks, tougher than normal stone.
Row 1, column 5: tile_gold.png - gold ore block tile, gray stone with bright round gold nuggets embedded, no cyan crystals, no diamond silhouette.
Row 1, column 6: tile_gem.png - cyan crystal vein ore block tile, gray stone with thin glowing cyan cracks and small embedded crystal shards, no large standalone diamond.

Row 2, column 1: tile_chest.png - treasure chest block tile, small wooden chest built into dirt and stone, cyan lock glow, no loose coins, no standalone gem.
Row 2, column 2: tile_lava.png - lava hazard tile, molten orange-red lava pool inside cracked dark stone, hot glow, no chest, no spikes, no gold.
Row 2, column 3: tile_spike.png - spike hazard tile, three sharp silver metal spikes rising from dark stone base, no lava, no chest, no gem.
Row 2, column 4: player_miner.png - compact miner character for a tile grid, above/front hybrid view, dark helmet, cyan headlamp glow, simple mining suit, chunky proportions.
Row 2, column 5: player_marker.png - glowing player marker, circular cyan ring with small dark miner helmet silhouette inside, white highlight, soft bloom, no diamond, no gemstone, no arrow.
Row 2, column 6: fx_mining_dust.png - mining dust effect, warm brown dust puffs, small debris chips, radial burst, loose particles only, no solid tile block.

Row 3, column 1: icon_coin.png - bright gold coin icon, simple round coin shape, polished bevel, no stack, no rock block.
Row 3, column 2: icon_gem.png - standalone glowing cyan diamond crystal icon, faceted diamond silhouette, no rock block, no coin, no player marker.
Row 3, column 3: icon_bomb.png - dark iron bomb icon with small fuse spark, round bomb silhouette, warm orange spark, no gem, no shield.
Row 3, column 4: icon_shield.png - blue steel shield icon with cyan rim light, clearly shield-shaped, no diamond, no gemstone, no button frame.
Row 3, column 5: icon_health.png - red heart icon for health, clearly heart-shaped, glossy red surface, warm glow, no crystal, no gemstone.
Row 3, column 6: icon_energy.png - cyan lightning battery icon for energy, rectangular battery shape with lightning bolt, no diamond, no shield.

Row 4, column 1: icon_depth.png - mine depth gauge icon, vertical depth meter with tick marks and tiny mine shaft symbol, no arrow shape, no tile block.
Row 4, column 2: icon_credits.png - stacked gold token icon for credits, three small gold tokens stacked, distinct from single coin icon, no rock block.
Row 4, column 3: fx_gem_sparkle.png - cyan sparkle effect, star-shaped glints and small light particles, soft bloom, radial burst, no diamond silhouette, no solid gem icon.
Row 4, column 4: fx_damage_flash.png - red-orange damage flash effect, sharp impact burst, small shards, heat glow, loose particles only, no solid tile block.
Row 4, column 5: fx_lava_glow.png - lava glow effect, orange-red heat shimmer and soft bloom edge, square tile compatible, transparent center fade, no solid lava tile.
Row 4, column 6: empty cell.

Row 5, column 1: button_left.png - dark metal-and-stone rounded square navigation button with one large high-contrast white arrow pointing LEFT.
Row 5, column 2: button_down.png - dark metal-and-stone rounded square navigation button with one large high-contrast white arrow pointing DOWN.
Row 5, column 3: button_right.png - dark metal-and-stone rounded square navigation button with one large high-contrast white arrow pointing RIGHT. Arrowhead must be on the right side. Do not create a left arrow. Do not create a shield. Do not create a gem.
Row 5, column 4: button_bomb.png - dark metal-and-stone rounded square action button with centered bomb icon, cyan edge highlight, no arrow, no shield, no gem.
Row 5, column 5: panel_stat_chip.png - compact stat chip panel, dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlight, blank center, no text, no logo, no icons.
Row 5, column 6: empty cell.

Row 6, columns 1-3 combined: title_logo.png - title logo containing only the readable words TOWER MINER. Chunky carved stone lettering, cyan glow accents, small cracks and mining scratches, centered horizontal logo composition, no HUD panel, no blank rectangle, no extra object to the right of the logo. This logo spans three cells inside one red bordered wide area.
Row 6, columns 4-5 combined: panel_hud.png - wide horizontal HUD panel frame, dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlights, blank center, no text, no logo, no icons. This panel spans two cells inside one red bordered wide area.
Row 6, column 6: empty cell.
```

## Slice Reference

After generating the sheet:

- Slice each normal cell as one square PNG.
- Slice `title_logo.png` as the combined Row 6 columns 1-3 region.
- Slice `panel_hud.png` as the combined Row 6 columns 4-5 region.
- Remove the red border from each final cutout before importing into Xcode.
- Rename each cutout using the filenames embedded in the prompt.

## Background Prompts

Generate backgrounds separately because they are full-screen opaque images, not cutout sheet assets.

## Menu Panel Graphic Prompt

Generate this separately for the graphic inside the rectangle under the title logo on the main menu.

### `menu_emblem.png`

```text
Create one transparent PNG image for Tower Miner.
Reference name: menu_emblem.png.
Target aspect ratio: 2:1 horizontal.
Background: transparent.

Asset:
A polished hero emblem for the main menu panel. Show a small dramatic underground mining scene: dark stone blocks framing a glowing cyan crystal core in the center, a few warm gold nuggets embedded in the rocks, subtle orange lava rim light near the bottom, and faint dust motes. The graphic should feel like a premium mobile game menu centerpiece.

Composition:
Single centered emblem only. No title text, no logo, no captions, no UI buttons, no HUD, no border, no panel frame. Keep the edges soft enough to sit inside an existing rounded rectangle panel. Leave transparent padding around the scene so it does not touch the panel edges.

Style:
Stylized mobile game art for Tower Miner, semi-pixel inspired but polished, dark underground fantasy mining theme, chunky readable shapes, crisp edges, subtle bevels, cyan glow accents, high contrast, modern iOS game quality, no watermark, no photorealism.
```

### `bg_menu.png`

```text
Create one portrait background image for Tower Miner.
Reference name: bg_menu.png.
Target aspect ratio: 3:4 portrait.
Background: opaque full-canvas image.
Scene: dark underground mine shaft, subtle stacked stone blocks, faint cyan glow near center, warm lava glow near bottom edge, high contrast but not busy, enough negative space for title and buttons, no text.
Style: stylized mobile game background, semi-pixel inspired but polished, no watermark, no UI mockup.
```

### `bg_run.png`

```text
Create one portrait background image for Tower Miner.
Reference name: bg_run.png.
Target aspect ratio: 3:4 portrait.
Background: opaque full-canvas image.
Scene: dark vertical mine shaft atmosphere, subtle stone grid, deep black center area for gameplay board, faint blue-gray rock texture, sparse cyan reflections, warm lava glow at bottom, not busy, no text.
Style: stylized mobile game background, semi-pixel inspired but polished, no watermark, no UI mockup.
```

### `bg_results.png`

```text
Create one portrait background image for Tower Miner.
Reference name: bg_results.png.
Target aspect ratio: 3:4 portrait.
Background: opaque full-canvas image.
Scene: dark mine chamber with small pile of coins and glowing cyan crystals at the bottom, soft cyan and gold highlights, subdued center area for UI panels, no text.
Style: stylized mobile game background, semi-pixel inspired but polished, no watermark, no UI mockup.
```
