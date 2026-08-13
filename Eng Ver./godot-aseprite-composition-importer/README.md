# Aseprite Composition Importer（Godot 4.7）

这个编辑器脚本会读取 Aseprite 导出的 `layers.json`，并在当前 `Node2D` 下创建对应的 `Sprite2D` 图层，按原始 `x/y` 坐标和图层顺序还原 composition。

## 放置文件

将 Aseprite 导出的整个文件夹放进 Godot 项目。例如：

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

将 `aseprite_composition.gd` 复制到项目的 `res://tools/`（或任意项目内目录）。不要放在项目外部。

## 使用

1. 新建场景，根节点选择 `Node2D`，例如命名为 `Forest`。
2. 将 `aseprite_composition.gd` 挂到该根节点。
3. 选中根节点，在 Inspector 的 **Aseprite Composition** 区域，将 **Layers Json** 选为：
   `res://assets/compositions/forest/layers.json`
4. 点击 **Rebuild from layers.json**。
5. 在场景树中会出现 `__AsepriteLayers`，其下是自动生成的 `Sprite2D`。
6. 按 **Cmd+S** 保存 `forest.tscn`。

每次在 Aseprite 重新导出同一文件夹后，回到 Godot，等 PNG 完成导入，再在该场景点击一次 **Rebuild from layers.json** 并保存。

## 注意

- 该工具只删除并重建 `__AsepriteLayers` 内的自动生成节点；你自己在场景中创建的节点不会被删除。
- 输出按照 Aseprite 图层从底到顶的顺序绘制。
- 自动生成的 `Sprite2D` 使用最近邻过滤（Nearest），适合像素画。
- 生成节点的坐标以根 `Node2D` 左上角为 `(0, 0)`。若需要移动整张 composition，只移动根节点即可。

## License & Disclaimer

Licensed under the [MIT License](../../LICENSE). This software is provided "AS IS", without warranty of any kind. Back up your files before use; use it at your own risk.
