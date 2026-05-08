# Tower Miner Asset Prompts

Use these prompts one at a time. Each prompt asks for exactly one PNG with a specific filename and size, which avoids the duplicate/missing-asset problems caused by bulk sheets.

## Global Rules

Add this intent to every prompt:

```text
Stylized mobile game art for Tower Miner, semi-pixel inspired but polished, dark underground fantasy mining theme, chunky readable shapes, crisp edges, subtle bevels, soft bloom, high contrast, modern iOS game quality, no watermark, no photorealism.
```

For asset-catalog sprites and UI pieces:

```text
Transparent background. Single centered asset only. The transparent area around the asset must be empty. No logo, no title, no text, no letters, no words, no subtitle, no labels, no captions, no filenames, no mockup, no UI panel unless the prompt is specifically for a panel, no character unless the prompt is specifically for a character, no icon unless the prompt is specifically for an icon, no decorative object below the asset, no object beside the asset, no background scene, no floor shadow extending beyond the asset, no border, no guide lines.
```

For full-screen backgrounds:

```text
Opaque full-canvas portrait PNG. No text, no UI mockup, no watermark.
```

## Tiles

### `tile_empty.png`

```text
Create one PNG named tile_empty.png.
Size: 512x512.
Background: transparent.
Asset: one empty dark mine shaft tile only. Mostly black interior, subtle blue-gray stone edge frame, open void center, readable as an empty traversable tile.
Hard exclusions: no logo, no title, no text, no letters, no words, no subtitle, no UI panel, no icon, no character, no decorative object below the tile, no object beside the tile, no background scene, no floor shadow extending beyond the tile.
Composition: the tile must be centered and fill most of the 512x512 canvas. The transparent area around the tile should be empty.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no watermark.
```

### `tile_dirt.png`

```text
Create one PNG named tile_dirt.png.
Size: 512x512.
Background: transparent.
Asset: one warm brown dirt block tile, earthy clay color, small embedded rocks, rough cracked surface, no metal, no gems, no gold.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

### `tile_stone.png`

```text
Create one PNG named tile_stone.png.
Size: 512x512.
Background: transparent.
Asset: one cool blue-gray stone block tile, clean cracked stone slabs, no gold, no gems, no dirt, no lava.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

### `tile_hard_stone.png`

```text
Create one PNG named tile_hard_stone.png.
Size: 512x512.
Background: transparent.
Asset: one darker hard stone block tile, reinforced heavy rock, deeper blue-gray color, stronger cracks, tougher and denser than normal stone, no gold, no gems.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

### `tile_gold.png`

```text
Create one PNG named tile_gold.png.
Size: 512x512.
Background: transparent.
Asset: one gold ore block tile, gray stone with clearly visible bright gold nuggets embedded, gold pieces must be round nugget shapes, no cyan crystals, no diamond silhouette.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

### `tile_gem.png`

```text
Create one PNG named tile_gem.png.
Size: 512x512.
Background: transparent.
Asset: one cyan crystal vein ore block tile, gray stone block with thin glowing cyan cracks and small embedded crystal shards, no large standalone diamond, still clearly a stone tile.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

### `tile_chest.png`

```text
Create one PNG named tile_chest.png.
Size: 512x512.
Background: transparent.
Asset: one treasure chest block tile, small wooden chest built into dirt and stone, cyan lock glow, readable as a reward tile, no loose coins, no standalone gem.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

### `tile_lava.png`

```text
Create one PNG named tile_lava.png.
Size: 512x512.
Background: transparent.
Asset: one lava hazard tile, molten orange-red lava pool inside cracked dark stone, hot glow, no chest, no spikes, no gold.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

### `tile_spike.png`

```text
Create one PNG named tile_spike.png.
Size: 512x512.
Background: transparent.
Asset: one spike hazard tile, three sharp silver metal spikes rising from a dark stone base, danger contrast, no lava, no chest, no gem.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, chunky shape, crisp edges, subtle bevel, top-left lighting, dark underground mining theme, no text, no watermark, no extra objects.
```

## Player

### `player_miner.png`

```text
Create one PNG named player_miner.png.
Size: 512x512.
Background: transparent.
Asset: one compact miner character for a tile grid, above/front hybrid view, dark helmet, cyan headlamp glow, simple mining suit, chunky proportions, readable at tiny size, no pickaxe extending outside the silhouette.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, subtle bevel, dark underground mining theme, no text, no watermark, no extra objects.
```

### `player_marker.png`

```text
Create one PNG named player_marker.png.
Size: 512x512.
Background: transparent.
Asset: one glowing player marker, circular cyan ring with a small dark miner helmet silhouette inside, white highlight, soft bloom, no diamond, no gemstone, no arrow.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, high contrast, no text, no watermark, no extra objects.
```

## Icons

### `icon_coin.png`

```text
Create one PNG named icon_coin.png.
Size: 512x512.
Background: transparent.
Asset: one bright gold coin icon, simple round coin shape, polished bevel, readable at 32px, no stack, no rock block.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, soft glow, no text, no watermark, no extra objects.
```

### `icon_gem.png`

```text
Create one PNG named icon_gem.png.
Size: 512x512.
Background: transparent.
Asset: one standalone glowing cyan diamond crystal icon, faceted diamond silhouette, no rock block, no coin, no player marker.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, soft cyan bloom, high contrast, no text, no watermark, no extra objects.
```

### `icon_bomb.png`

```text
Create one PNG named icon_bomb.png.
Size: 512x512.
Background: transparent.
Asset: one dark iron bomb icon with small fuse spark, round bomb silhouette, warm orange spark, no gem, no shield.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, subtle bevel, no text, no watermark, no extra objects.
```

### `icon_shield.png`

```text
Create one PNG named icon_shield.png.
Size: 512x512.
Background: transparent.
Asset: one blue steel shield icon with cyan rim light, clearly shield-shaped, no diamond, no gemstone, no button frame.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, subtle bevel, high contrast, no text, no watermark, no extra objects.
```

### `icon_health.png`

```text
Create one PNG named icon_health.png.
Size: 512x512.
Background: transparent.
Asset: one red heart icon for health, clearly heart-shaped, glossy red surface, warm glow, no crystal, no gemstone.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, high contrast, no text, no watermark, no extra objects.
```

### `icon_energy.png`

```text
Create one PNG named icon_energy.png.
Size: 512x512.
Background: transparent.
Asset: one cyan lightning battery icon for energy, rectangular battery shape with lightning bolt, no diamond, no shield.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, cyan glow, no text, no watermark, no extra objects.
```

### `icon_depth.png`

```text
Create one PNG named icon_depth.png.
Size: 512x512.
Background: transparent.
Asset: one mine depth gauge icon, vertical depth meter with tick marks and a tiny mine shaft symbol, no arrow shape, no tile block.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, cyan highlights, no text, no watermark, no extra objects.
```

### `icon_credits.png`
```text
Create one PNG named icon_credits.png.
Size: 512x512.
Background: transparent.
Asset: one stacked gold token icon for credits, three small gold tokens stacked, distinct from the single coin icon, no rock block.
Style: stylized mobile game art for Tower Miner, semi-pixel inspired but polished, crisp edges, warm gold glow, no text, no watermark, no extra objects.
```

## Buttons

### `button_left.png`

```text
Create one PNG named button_left.png.
Size: 512x512.
Background: transparent.
Asset: one dark metal-and-stone rounded square navigation button with one large high-contrast white arrow pointing LEFT. Arrowhead on the left side, tail starts on the right side. No other arrows, no shield, no gem.
Style: stylized mobile game UI for Tower Miner, semi-pixel inspired but polished, cyan edge highlight, subtle bevel, no text, no watermark, no extra objects.
```

### `button_down.png`

```text
Create one PNG named button_down.png.
Size: 512x512.
Background: transparent.
Asset: one dark metal-and-stone rounded square navigation button with one large high-contrast white arrow pointing DOWN. Arrowhead at the bottom, tail starts at the top. No other arrows, no shield, no gem.
Style: stylized mobile game UI for Tower Miner, semi-pixel inspired but polished, cyan edge highlight, subtle bevel, no text, no watermark, no extra objects.
```

### `button_right.png`

```text
Create one PNG named button_right.png.
Size: 512x512.
Background: transparent.
Asset: one dark metal-and-stone rounded square navigation button with one large high-contrast white arrow pointing RIGHT. Arrowhead on the right side, tail starts on the left side. Do not create a left arrow. Do not create a shield. Do not create a gem.
Style: stylized mobile game UI for Tower Miner, semi-pixel inspired but polished, cyan edge highlight, subtle bevel, no text, no watermark, no extra objects.
```

### `button_bomb.png`

```text
Create one PNG named button_bomb.png.
Size: 512x512.
Background: transparent.
Asset: one dark metal-and-stone rounded square action button with a centered bomb icon, cyan edge highlight, no arrow, no shield, no gem.
Style: stylized mobile game UI for Tower Miner, semi-pixel inspired but polished, subtle bevel, no text, no watermark, no extra objects.
```

## Effects

### `fx_mining_dust.png`

```text
Create one PNG named fx_mining_dust.png.
Size: 512x512.
Background: transparent.
Asset: one mining dust effect, warm brown dust puffs, small debris chips, radial burst, loose particles only, no solid tile block.
Style: stylized mobile game VFX for Tower Miner, semi-pixel inspired but polished, soft edges, no text, no watermark, no extra objects.
```

### `fx_gem_sparkle.png`

```text
Create one PNG named fx_gem_sparkle.png.
Size: 512x512.
Background: transparent.
Asset: one cyan sparkle effect, star-shaped glints and small light particles, soft bloom, radial burst, no diamond silhouette, no solid gem icon.
Style: stylized mobile game VFX for Tower Miner, semi-pixel inspired but polished, crisp highlights, no text, no watermark, no extra objects.
```

### `fx_damage_flash.png`

```text
Create one PNG named fx_damage_flash.png.
Size: 512x512.
Background: transparent.
Asset: one red-orange damage flash effect, sharp impact burst, small shards, heat glow, loose particles only, no solid tile block.
Style: stylized mobile game VFX for Tower Miner, semi-pixel inspired but polished, high contrast, no text, no watermark, no extra objects.
```

### `fx_lava_glow.png`

```text
Create one PNG named fx_lava_glow.png.
Size: 512x512.
Background: transparent.
Asset: one lava glow effect, orange-red heat shimmer and soft bloom edge, square tile compatible, transparent center fade, no solid lava tile.
Style: stylized mobile game VFX for Tower Miner, semi-pixel inspired but polished, no text, no watermark, no extra objects.
```

## Logo And Panels

### `title_logo.png`

```text
Create one PNG named title_logo.png.
Size: 1536x512.
Background: transparent.
Asset: title logo containing only the readable words TOWER MINER. Chunky carved stone lettering, cyan glow accents, small cracks and mining scratches, centered horizontal logo composition, no large diamond icon, no HUD panel, no blank rectangle, no extra object to the right of the logo.
Style: stylized mobile game logo for Tower Miner, semi-pixel inspired but polished, high contrast, no subtitle, no watermark, no background scene.
```

### `panel_hud.png`

```text
Create one PNG named panel_hud.png.
Size: 1024x512.
Background: transparent.
Asset: one wide horizontal HUD panel frame, dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlights, blank center, no text, no logo, no icons.
Style: stylized mobile game UI for Tower Miner, semi-pixel inspired but polished, subtle bevel, high contrast, no watermark, no extra objects.
```

### `panel_stat_chip.png`

```text
Create one PNG named panel_stat_chip.png.
Size: 512x512.
Background: transparent.
Asset: one compact stat chip panel, dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlight, blank center, no text, no logo, no icons.
Style: stylized mobile game UI for Tower Miner, semi-pixel inspired but polished, subtle bevel, high contrast, no watermark, no extra objects.
```

### `panel_results.png`

```text
Create one PNG named panel_results.png.
Size: 1024x1024.
Background: transparent.
Asset: one large results panel frame, dark translucent mining cockpit style, stone-and-metal frame, cyan rim highlights, blank center for reward summary, no text, no logo, no icons.
Style: stylized mobile game UI for Tower Miner, semi-pixel inspired but polished, subtle bevel, high contrast, no watermark, no extra objects.
```

## Backgrounds

### `bg_menu.png`

```text
Create one PNG named bg_menu.png.
Size: 1536x2048.
Background: opaque full-canvas image.
Asset: portrait mobile game menu background for Tower Miner, dark underground mine shaft, subtle stacked stone blocks, faint cyan glow near center, warm lava glow near bottom edge, high contrast but not busy, enough negative space for title and buttons, no text.
Style: stylized mobile game background for Tower Miner, semi-pixel inspired but polished, no watermark, no UI mockup.
```

### `bg_run.png`

```text
Create one PNG named bg_run.png.
Size: 1536x2048.
Background: opaque full-canvas image.
Asset: portrait gameplay background for Tower Miner, dark vertical mine shaft atmosphere, subtle stone grid, deep black center area for gameplay board, faint blue-gray rock texture, sparse cyan reflections, warm lava glow at bottom, not busy, no text.
Style: stylized mobile game background for Tower Miner, semi-pixel inspired but polished, no watermark, no UI mockup.
```

### `bg_results.png`

```text
Create one PNG named bg_results.png.
Size: 1536x2048.
Background: opaque full-canvas image.
Asset: portrait results screen background for Tower Miner, dark mine chamber with small pile of coins and glowing cyan crystals at the bottom, soft cyan and gold highlights, subdued center area for UI panels, no text.
Style: stylized mobile game background for Tower Miner, semi-pixel inspired but polished, no watermark, no UI mockup.
```
