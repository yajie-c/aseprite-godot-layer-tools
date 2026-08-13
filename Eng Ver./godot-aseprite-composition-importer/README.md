# Aseprite Composition Importer (Godot 4.7)

This editor script reads an Aseprite-exported `layers.json` file and creates matching `Sprite2D` layers under the current `Node2D`, restoring the original `x/y` positions and layer order.

## File Placement

Put the complete Aseprite export folder inside your Godot project. For example:

```text
res://
  assets/compositions/forest/
    layers.json
    background.png
    tree.png
    player.png
  scenes/forest.tscn
  tools/aseprite_composition.gd
```

Copy `aseprite_composition.gd` into `res://tools/` (or any folder inside your Godot project). Do not leave it outside the project folder.

## Usage

1. Create a new scene with a `Node2D` root node, for example `Forest`.
2. Attach `aseprite_composition.gd` to the root node.
3. Select the root node. In the Inspector under **Aseprite Composition**, set **Layers Json** to:
   `res://assets/compositions/forest/layers.json`
4. Click **Rebuild from layers.json**.
5. A `__AsepriteLayers` node containing generated `Sprite2D` nodes will appear in the Scene tree.
6. Press **Cmd+S** to save `forest.tscn`.

After exporting the same folder from Aseprite again, return to Godot, wait for the PNG files to finish importing, then click **Rebuild from layers.json** again and save the scene.

## Notes

- The tool only removes and rebuilds generated nodes inside `__AsepriteLayers`; nodes you create elsewhere in the scene are not removed.
- Layers are drawn from bottom to top, matching the Aseprite layer order.
- Generated `Sprite2D` nodes use Nearest texture filtering, which is suitable for pixel art.
- The root `Node2D`'s `(0, 0)` position corresponds to the top-left corner of the Aseprite canvas. Move the root node to move the entire composition.

## License & Disclaimer

Licensed under the [MIT License](../../LICENSE). This software is provided "AS IS", without warranty of any kind. Back up your files before use; use it at your own risk.
