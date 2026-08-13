# 可见图层裁剪导出器（中文界面）

## 安装到 Aseprite（macOS）

1. 如果 Aseprite 正在运行，请先退出。
2. 双击本文件夹中的 `trimmed-visible-layer-exporter.aseprite-extension`。
3. Aseprite 弹出安装提示后，点击 **安装**；如有提示，请重新打开 Aseprite。
4. 随便打开一个 Aseprite 文件，确认能在 **文件 > 脚本 > 导出可见图层（自动裁剪）** 找到工具。

如果双击没有打开 Aseprite：在 Aseprite 中打开 **偏好设置 > 扩展 > 添加扩展**，选择 `trimmed-visible-layer-exporter.aseprite-extension`，然后点击 **打开**。

## 导出

1. 在 Aseprite 打开场景文件，并切到要导出的帧。
2. 点击 **文件 > 脚本 > 导出可见图层（自动裁剪）**。
3. 选择 `layers.json` 的保存位置；同一文件夹会生成裁剪后的 PNG。

只导出当前帧中的可见像素图层；隐藏图层、隐藏组内容、图层组本身和空图层都会跳过。
