# Trimmed Visible Layer Exporter (English UI)

## Install in Aseprite (macOS)

1. Quit Aseprite if it is currently open.
2. Double-click `trimmed-visible-layer-exporter.aseprite-extension` in this folder.
3. When Aseprite asks to install the extension, click **Install**. Reopen Aseprite if requested.
4. Open any sprite and confirm that **File > Scripts > Export Visible Layers (Trimmed)** is available.

If double-clicking does not open Aseprite: open **Aseprite > Preferences > Extensions**, click **Add Extension**, select `trimmed-visible-layer-exporter.aseprite-extension`, then click **Open**.

## Export

1. Open an Aseprite scene and switch to the frame to export.
2. Click **File > Scripts > Export Visible Layers (Trimmed)**.
3. Choose where to save `layers.json`. The cropped PNG files are saved beside it.

Only visible pixel layers in the current frame are exported. Hidden layers, hidden groups, groups themselves, and empty layers are skipped.
