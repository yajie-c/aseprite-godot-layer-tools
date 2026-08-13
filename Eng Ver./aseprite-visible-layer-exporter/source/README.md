# Trimmed Visible Layer Exporter

Aseprite 扩展：将当前帧中所有可见的普通像素图层分别导出为紧贴内容边界的 PNG。

## 安装（macOS）

双击同目录中的 `trimmed-visible-layer-exporter.aseprite-extension`，在 Aseprite 的安装提示中确认即可。

如果双击没有反应：打开 **Aseprite > Preferences > Extensions > Add Extension**，选择该文件。

## 使用

1. 在 Aseprite 打开场景文件，并切换到要导出的帧。
2. 选择 **File > Scripts > Export Visible Layers (Trimmed)**。
3. 在弹出的保存窗口中选择导出目录，并将 `layers.json` 保存到那里。
4. 同目录会生成每个图层的 PNG 与 `layers.json`。

## 规则

- 只处理当前帧。
- 只处理实际可见的普通像素图层；隐藏图层和隐藏组内图层会忽略。
- 图层组仅作为容器，不会单独导出；其可见子图层会分别导出。
- 空图层自动跳过。
- PNG 会裁掉透明边缘，保留 alpha 透明度。
- 文件名来自图层名；不适合 macOS 文件名的字符会替换为 `_`，重复名称会自动加编号。
- 再次导出到同一目录会覆盖同名 PNG 和 JSON。

`layers.json` 记录裁剪 PNG 原先在画布中的坐标，例如：

```json
{
  "canvas": { "width": 320, "height": 180 },
  "frame": 1,
  "layers": [
    { "name": "tree", "file": "tree.png", "x": 42, "y": 71, "width": 16, "height": 24 }
  ]
}
```

之后在 Godot 中使用这些 PNG 时，可用 `x` 与 `y` 将其放回 Aseprite 场景内的原位置。
