-- Trimmed Visible Layer Exporter for Aseprite
-- Exports visible pixel layers from the current frame as tightly cropped PNGs.

local function is_effectively_visible(layer, parent_is_visible)
  if not parent_is_visible or not layer.isVisible then
    return false
  end
  return true
end

local function collect_visible_pixel_layers(layers, parent_is_visible, result)
  for _, layer in ipairs(layers) do
    local visible = is_effectively_visible(layer, parent_is_visible)

    if layer.isGroup then
      -- A group is only a container: export its visible leaf layers.
      collect_visible_pixel_layers(layer.layers, visible, result)
    elseif visible and not layer.isTilemap then
      table.insert(result, layer)
    end
  end
end

local function collect_all_layers(layers, result)
  for _, layer in ipairs(layers) do
    table.insert(result, layer)
    if layer.isGroup then
      collect_all_layers(layer.layers, result)
    end
  end
end

local function safe_file_stem(name, used_names)
  -- Keep Unicode layer names intact, replacing only characters unsafe in filenames.
  local stem = name:gsub('[<>:"/%?%*|]', "_")
  stem = stem:gsub("\\", "_")
  stem = stem:gsub("^%s+", ""):gsub("%s+$", "")
  stem = stem:gsub("%.$", "")
  if stem == "" or stem == "." or stem == ".." then
    stem = "layer"
  end

  local candidate = stem
  local number = 2
  -- macOS volumes are usually case-insensitive, so avoid case-only collisions.
  while used_names[candidate:lower()] do
    candidate = stem .. "_" .. number
    number = number + 1
  end
  used_names[candidate:lower()] = true
  return candidate
end

local function json_string(value)
  value = tostring(value)
  value = value:gsub("\\", "\\\\")
  value = value:gsub('"', '\\"')
  value = value:gsub("[%z\1-\31]", function(character)
    return string.format("\\u%04x", string.byte(character))
  end)
  return '"' .. value .. '"'
end

local function default_metadata_path(sprite)
  local base_path = app.fs.userDocsPath
  if sprite.filename and sprite.filename ~= "" then
    base_path = app.fs.filePath(sprite.filename)
  end
  return app.fs.joinPath(base_path, "layers.json")
end

local function choose_metadata_path(sprite)
  local accepted = false
  local dlg = Dialog{ title="导出可见图层（自动裁剪）" }
  dlg:label{
    text="将当前帧中所有可见像素图层导出为自动裁剪的 PNG。\n"
      .. "请选择 layers.json 的保存位置；PNG 会保存在同一文件夹。"
  }
  dlg:file{
    id="metadata_path",
    label="导出位置",
    title="保存 layers.json",
    save=true,
    filename=default_metadata_path(sprite),
    filetypes={ "json" }
  }
  dlg:button{
    id="export",
    text="导出",
    focus=true,
    onclick=function()
      accepted = true
      dlg:close()
    end
  }
  dlg:button{ id="cancel", text="取消" }
  dlg:show()

  if not accepted then
    return nil
  end

  local filename = dlg.data.metadata_path
  if not filename or filename == "" then
    return nil
  end
  if app.fs.fileExtension(filename):lower() ~= "json" then
    filename = filename .. ".json"
  end
  return filename
end

local function render_only_layer(sprite, frame_number, target_layer, all_layers)
  local original_visibility = {}
  for index, layer in ipairs(all_layers) do
    original_visibility[index] = layer.isVisible
    layer.isVisible = false
  end

  -- Always put the document back exactly as it was, even if rendering fails.
  local ok, image_or_error = xpcall(function()
    -- A child cannot render while an ancestor group is hidden.
    target_layer.isVisible = true
    local parent = target_layer.parent
    while parent and parent ~= sprite do
      parent.isVisible = true
      parent = parent.parent
    end

    local image = Image(sprite.spec)
    image:drawSprite(sprite, frame_number)
    return image
  end, debug.traceback)

  for index, layer in ipairs(all_layers) do
    layer.isVisible = original_visibility[index]
  end

  if not ok then
    error(image_or_error)
  end
  return image_or_error
end

local function write_metadata(filename, sprite, frame_number, exported_layers)
  local file, error_message = io.open(filename, "w")
  if not file then
    error("Could not write metadata file: " .. tostring(error_message))
  end

  file:write("{\n")
  file:write("  \"format\": \"aseprite-trimmed-visible-layers\",\n")
  file:write("  \"canvas\": { \"width\": ", sprite.width,
             ", \"height\": ", sprite.height, " },\n")
  file:write("  \"frame\": ", frame_number, ",\n")
  file:write("  \"layers\": [\n")
  for index, entry in ipairs(exported_layers) do
    file:write("    { \"name\": ", json_string(entry.name),
               ", \"file\": ", json_string(entry.file),
               ", \"x\": ", entry.x,
               ", \"y\": ", entry.y,
               ", \"width\": ", entry.width,
               ", \"height\": ", entry.height, " }")
    if index < #exported_layers then
      file:write(",")
    end
    file:write("\n")
  end
  file:write("  ]\n}\n")
  file:close()
end

local function export_visible_layers()
  local sprite = app.activeSprite
  if not sprite then
    app.alert("请先打开一个 Aseprite 文件，再导出图层。")
    return
  end

  local metadata_path = choose_metadata_path(sprite)
  if not metadata_path then
    return
  end

  local output_directory = app.fs.filePath(metadata_path)
  if output_directory == "" then
    output_directory = app.fs.currentPath
    metadata_path = app.fs.joinPath(output_directory, metadata_path)
  end
  if not app.fs.isDirectory(output_directory) then
    app.fs.makeAllDirectories(output_directory)
  end

  local layers_to_export = {}
  collect_visible_pixel_layers(sprite.layers, true, layers_to_export)
  if #layers_to_export == 0 then
    app.alert("没有可导出的可见像素图层。")
    return
  end

  local all_layers = {}
  collect_all_layers(sprite.layers, all_layers)
  local frame_number = app.frame.frameNumber
  local used_names = {}
  local exported_layers = {}
  local empty_count = 0

  local ok, failure = xpcall(function()
    for _, layer in ipairs(layers_to_export) do
      local rendered = render_only_layer(sprite, frame_number, layer, all_layers)
      local bounds = rendered:shrinkBounds()

      if bounds.width > 0 and bounds.height > 0 then
        local cropped = Image(rendered, bounds)
        local filename = safe_file_stem(layer.name, used_names) .. ".png"
        cropped:saveAs(app.fs.joinPath(output_directory, filename))
        table.insert(exported_layers, {
          name=layer.name,
          file=filename,
          x=bounds.x,
          y=bounds.y,
          width=bounds.width,
          height=bounds.height
        })
      else
        empty_count = empty_count + 1
      end
    end
    write_metadata(metadata_path, sprite, frame_number, exported_layers)
  end, debug.traceback)

  -- render_only_layer normally restores visibility itself. This refresh makes
  -- the restored layer visibility immediately appear in the editor.
  app.refresh()

  if not ok then
    app.alert{ title="导出失败", text=tostring(failure) }
    return
  end

  local message = string.format("已导出 %d 个图层到：\n%s",
    #exported_layers, output_directory)
  if empty_count > 0 then
    message = message .. string.format("\n已跳过 %d 个空图层。", empty_count)
  end
  app.alert{ title="导出完成", text=message }
end

function init(plugin)
  plugin:newCommand{
    id="TrimmedVisibleLayerExporterCN",
    title="导出可见图层（自动裁剪）",
    group="file_scripts",
    onenabled=function()
      return app.activeSprite ~= nil
    end,
    onclick=export_visible_layers
  }
end
