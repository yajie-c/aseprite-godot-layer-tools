# Aseprite 场景还原器（Godot 4.7）

此编辑器脚本会读取 Aseprite 导出的 `layers.json` 文件，并在当前 `Node2D` 下创建对应的 `Sprite2D` 图层，按原始 `x/y` 坐标与图层顺序还原场景。

## 文件放置

将 Aseprite 导出的整个文件夹放入 Godot 项目中。例如：

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

将 `aseprite_composition.gd` 复制到 `res://tools/`（或 Godot 项目内的任意目录）。请勿将脚本放在项目目录外。

## 使用方法

1. 新建一个场景，根节点选择 `Node2D`，例如命名为 `Forest`。
2. 将 `aseprite_composition.gd` 挂载到根节点。
3. 选中根节点，在 Inspector 的 **Aseprite 场景还原** 分类中，将 **Layers Json** 设置为：
   `res://assets/compositions/forest/layers.json`
4. 点击 **从 layers.json 重建**。
5. 场景树中会出现 `__AsepriteLayers` 节点，里面包含自动生成的 `Sprite2D` 节点。
6. 按 **Cmd+S** 保存 `forest.tscn`。

当你再次从 Aseprite 导出到同一文件夹后，回到 Godot，等待 PNG 导入完成，再点击一次 **从 layers.json 重建** 并保存场景。

## 注意事项

- 工具只会删除和重建 `__AsepriteLayers` 内自动生成的节点；你在场景其他位置创建的节点不会被删除。
- 图层会按照 Aseprite 从底到顶的顺序绘制。
- 自动生成的 `Sprite2D` 使用最近邻（Nearest）纹理过滤，适合像素画。
- 根 `Node2D` 的 `(0, 0)` 对应 Aseprite 画布左上角；移动根节点即可移动整个场景。

## 协议与免责声明

本工具采用 [MIT 开源协议](../../LICENSE)。软件按原样提供，不提供任何担保；使用前请备份文件，使用风险由使用者自行承担。
