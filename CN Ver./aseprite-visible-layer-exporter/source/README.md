# 可见图层裁剪导出器（中文界面）

## 使用

1. 安装同级的 `trimmed-visible-layer-exporter.aseprite-extension`。
2. 在 Aseprite 中打开文件，点击 **文件 > 脚本 > 导出可见图层（自动裁剪）**。
3. 选择 `layers.json` 的保存位置；同一文件夹会生成 PNG 与 `layers.json`。

- 只导出当前帧中的可见像素图层；隐藏图层、空图层与图层组本身会跳过。
- PNG 会自动裁掉透明边缘，并保留透明度。
