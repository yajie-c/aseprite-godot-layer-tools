# Aseprite 场景还原器（中文界面，Godot 4.7）

## 使用

1. 将 Aseprite 导出的 PNG 与 `layers.json` 整个文件夹放进 Godot 项目，例如 `res://assets/compositions/forest/`。
2. 新建一个 `Node2D` 场景，将 `aseprite_composition.gd` 挂到根节点；在 Inspector 中选择 `layers.json`。
3. 点击 **从 layers.json 重建**，再按 **Cmd+S** 保存场景。

更新时，覆盖导出同一文件夹，等 Godot 导入 PNG 后，再点击一次重建并保存即可。

工具只会清空和重建 `__AsepriteLayers` 内自动生成的节点，不会删除你自己创建的节点。
