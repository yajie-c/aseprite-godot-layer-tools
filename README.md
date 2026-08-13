# Aseprite → Godot Layer Tools / 图层工具

[English](#english) · [中文](#中文)

---

<a id="english"></a>
# English

A small two-part workflow for pixel-art scenes:

1. **Aseprite exporter** — exports every visible pixel layer in the current frame as a tightly cropped PNG, plus a `layers.json` file containing the original positions.
2. **Godot importer** — reads `layers.json` and rebuilds the composition as `Sprite2D` nodes in a `Node2D` scene.

> Designed for Godot 4.7 and desktop Aseprite on macOS. It may work on other recent versions, but they have not been tested.

## Download

### Option A: Download the whole repository

1. Click the green **Code** button at the top of this GitHub page.
2. Click **Download ZIP**.
3. Unzip the downloaded file.
4. Choose one language folder:
   - `Eng Ver.` — English Aseprite/Godot interface text
   - `CN Ver.` — Chinese Aseprite/Godot interface text

### Option B: Download only the Aseprite extension

Open one of these folders and download the `.aseprite-extension` file:

- English: `Eng Ver./aseprite-visible-layer-exporter/trimmed-visible-layer-exporter.aseprite-extension`
- Chinese: `CN Ver./aseprite-visible-layer-exporter/trimmed-visible-layer-exporter.aseprite-extension`

On GitHub, open the file, click the **…** menu, then choose **Download**.

## 1. Install the Aseprite exporter

1. Quit Aseprite if it is open.
2. Double-click `trimmed-visible-layer-exporter.aseprite-extension` from your chosen language folder.
3. Click **Install** in Aseprite's installation prompt.
4. Reopen Aseprite if requested.
5. Confirm the command appears in **File > Scripts**:
   - English: **Export Visible Layers (Trimmed)**
   - Chinese: **导出可见图层（自动裁剪）**

If double-clicking does not work: open **Aseprite > Preferences > Extensions > Add Extension**, then choose the `.aseprite-extension` file.

## 2. Export from Aseprite

1. Open your Aseprite scene and select the frame you want to export.
2. Run the exporter from **File > Scripts**.
3. Select a location and save `layers.json`.
4. The same folder will contain `layers.json` and one cropped PNG per visible pixel layer.

Export rules:

- Only the **current frame** is exported.
- Visible pixel layers are exported separately.
- Hidden layers, layers inside hidden groups, empty layers, and groups themselves are skipped.
- Transparent borders are trimmed while alpha transparency is preserved.

Example export folder:

```text
forest/
  layers.json
  background.png
  tree.png
  player.png
```

## 3. Rebuild the scene in Godot

1. Copy the entire export folder into your Godot project, for example:

   ```text
   res://assets/compositions/forest/
     layers.json
     background.png
     tree.png
     player.png
   ```

2. Copy the Godot script from your selected language folder into the Godot project, for example:

   ```text
   Eng Ver./godot-aseprite-composition-importer/aseprite_composition.gd
   → res://tools/aseprite_composition.gd
   ```

3. Create a new `Node2D` scene, for example `res://scenes/forest.tscn`.
4. Attach `aseprite_composition.gd` to the root `Node2D`.
5. Select the root node. In the Inspector, set **Layers Json** to:

   ```text
   res://assets/compositions/forest/layers.json
   ```

6. Click the rebuild button:
   - English: **Rebuild from layers.json**
   - Chinese: **从 layers.json 重建**
7. Save the scene with **Cmd+S**.

Godot creates a `__AsepriteLayers` child node containing generated `Sprite2D` layers. The root node's `(0, 0)` is the Aseprite canvas top-left corner.

## Update workflow

After changing the scene in Aseprite:

1. Export again to the same folder and allow it to overwrite the old PNG/JSON files.
2. Return to Godot and wait for the PNG files to finish importing.
3. Open the composition scene, click **Rebuild**, then save it again.

Only the generated nodes inside `__AsepriteLayers` are replaced. Your own nodes outside that container are not removed.

## License & Disclaimer

Licensed under the [MIT License](./LICENSE).

This software is provided **"AS IS"**, without warranty of any kind. Back up your project, Aseprite files, and exported assets before use. You are responsible for checking export paths and generated results; use this software at your own risk.

---

<a id="中文"></a>
# 中文

一套给像素场景使用的小工具流程：

1. **Aseprite 导出器**：将当前帧中所有可见的像素图层分别导出为自动裁剪的 PNG，并生成记录原始位置的 `layers.json`。
2. **Godot 还原器**：读取 `layers.json`，在 `Node2D` 场景中创建 `Sprite2D`，还原 Aseprite 里的图层 composition。

> 为 macOS 桌面版 Aseprite 与 Godot 4.7 制作。其他近期版本可能可以使用，但尚未测试。

## 下载

### 方法 A：下载整个仓库

1. 点击本 GitHub 页面顶部绿色的 **Code** 按钮。
2. 点击 **Download ZIP**。
3. 解压下载的 ZIP 文件。
4. 选择一个语言版本：
   - `Eng Ver.`：Aseprite / Godot 操作界面为英文
   - `CN Ver.`：Aseprite / Godot 操作界面为中文

### 方法 B：只下载 Aseprite 扩展

进入以下任一目录，下载 `.aseprite-extension` 文件：

- 英文版：`Eng Ver./aseprite-visible-layer-exporter/trimmed-visible-layer-exporter.aseprite-extension`
- 中文版：`CN Ver./aseprite-visible-layer-exporter/trimmed-visible-layer-exporter.aseprite-extension`

在 GitHub 中打开文件后，点击 **…** 菜单并选择 **Download**。

## 1. 安装 Aseprite 导出器

1. 如果 Aseprite 正在运行，请先退出。
2. 在你选择的语言版本文件夹中，双击 `trimmed-visible-layer-exporter.aseprite-extension`。
3. 在 Aseprite 的安装提示中点击 **Install / 安装**。
4. 如有提示，请重新打开 Aseprite。
5. 在 **文件 > 脚本** 中确认能找到：
   - 英文版：**Export Visible Layers (Trimmed)**
   - 中文版：**导出可见图层（自动裁剪）**

如果双击没有打开 Aseprite：在 Aseprite 中依次打开 **偏好设置 > 扩展 > 添加扩展**，再选择 `.aseprite-extension` 文件。

## 2. 从 Aseprite 导出

1. 打开 Aseprite 场景文件，并选中要导出的帧。
2. 在 **文件 > 脚本** 中运行导出器。
3. 选择保存位置，保存 `layers.json`。
4. 同一文件夹会生成 `layers.json` 和每个可见图层对应的裁剪 PNG。

导出规则：

- 只导出**当前帧**。
- 每个可见像素图层会单独导出。
- 隐藏图层、隐藏组中的图层、空图层和图层组本身会跳过。
- 会裁掉透明边缘，并保留 alpha 透明度。

导出目录示例：

```text
forest/
  layers.json
  background.png
  tree.png
  player.png
```

## 3. 在 Godot 还原场景

1. 将整个导出文件夹复制到 Godot 项目内，例如：

   ```text
   res://assets/compositions/forest/
     layers.json
     background.png
     tree.png
     player.png
   ```

2. 将所选语言版本中的 Godot 脚本复制进项目，例如：

   ```text
   CN Ver./godot-aseprite-composition-importer/aseprite_composition.gd
   → res://tools/aseprite_composition.gd
   ```

3. 创建一个新的 `Node2D` 场景，例如 `res://scenes/forest.tscn`。
4. 将 `aseprite_composition.gd` 挂到根 `Node2D`。
5. 选中根节点，在 Inspector 中将 **Layers Json** 指向：

   ```text
   res://assets/compositions/forest/layers.json
   ```

6. 点击重建按钮：
   - 英文版：**Rebuild from layers.json**
   - 中文版：**从 layers.json 重建**
7. 按 **Cmd+S** 保存场景。

Godot 会创建名为 `__AsepriteLayers` 的子节点，里面是自动生成的 `Sprite2D` 图层。根节点的 `(0, 0)` 对应 Aseprite 画布左上角。

## 更新流程

当你在 Aseprite 修改场景后：

1. 再次导出到同一文件夹，覆盖旧 PNG 与 JSON。
2. 回到 Godot，等待 PNG 资源导入完成。
3. 打开该场景，点击一次 **重建**，然后再次保存。

工具只会替换 `__AsepriteLayers` 内自动生成的节点；你自己在此容器外创建的节点不会被删除。

## 协议与免责声明

本项目采用 [MIT 开源协议](./LICENSE)。

本软件按原样提供，不提供任何担保。使用前请备份 Godot 项目、Aseprite 文件和导出素材；请自行检查导出路径与生成结果，并自行承担使用风险。
