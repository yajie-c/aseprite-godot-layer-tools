@tool
extends Node2D
## Rebuilds this Node2D's Aseprite composition from a layers.json export.
##
## Attach this script to a Node2D in an editor scene, set layers_json, then use
## the "Rebuild from layers.json" button in the Inspector.

const GENERATED_CONTAINER_NAME := "__AsepriteLayers"
const GENERATED_META_KEY := "aseprite_composition_generated"

@export_category("Aseprite Composition")
@export_file("*.json") var layers_json: String
@export_tool_button("Rebuild from layers.json", "Reload") var rebuild_action = rebuild_from_json
@export_multiline var status: String = "Choose layers.json, then click Rebuild from layers.json."


func rebuild_from_json() -> void:
	if not Engine.is_editor_hint():
		return

	if layers_json.is_empty():
		_set_status("No layers.json selected.", true)
		return
	if not FileAccess.file_exists(layers_json):
		_set_status("File not found: " + layers_json, true)
		return

	var file := FileAccess.open(layers_json, FileAccess.READ)
	if file == null:
		_set_status("Could not open: " + layers_json, true)
		return

	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	if parse_error != OK:
		_set_status("Invalid JSON at line %d: %s" % [json.get_error_line(), json.get_error_message()], true)
		return

	var document = json.data
	if not (document is Dictionary) or not (document.get("layers", null) is Array):
		_set_status("This is not a valid Aseprite layers.json file.", true)
		return

	var container := _get_or_create_generated_container()
	_clear_generated_layers(container)

	var json_directory := layers_json.get_base_dir()
	var used_names: Dictionary = {}
	var imported_count := 0
	var missing_files: Array[String] = []

	# The exporter writes layers bottom-to-top, which is also Godot's draw order.
	for layer_data in document["layers"]:
		if not (layer_data is Dictionary):
			continue

		var png_file := String(layer_data.get("file", ""))
		var texture_path := json_directory.path_join(png_file)
		var texture := load(texture_path) as Texture2D
		if texture == null:
			missing_files.append(texture_path)
			continue

		var sprite := Sprite2D.new()
		sprite.name = _unique_node_name(String(layer_data.get("name", "Layer")), used_names)
		sprite.texture = texture
		sprite.centered = false
		sprite.position = Vector2(
			float(layer_data.get("x", 0)),
			float(layer_data.get("y", 0))
		)
		sprite.z_index = imported_count
		sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		sprite.set_meta("aseprite_layer_name", String(layer_data.get("name", "")))
		sprite.set_meta(GENERATED_META_KEY, true)
		container.add_child(sprite)
		_set_scene_owner(sprite)
		imported_count += 1

	var result := "Rebuilt %d Aseprite layer(s)." % imported_count
	if not missing_files.is_empty():
		result += "\nMissing PNG file(s):\n" + "\n".join(missing_files)
		_set_status(result, true)
	else:
		_set_status(result + "\nSave this scene (Cmd+S) to keep the generated Sprite2D nodes.")


func _get_or_create_generated_container() -> Node2D:
	var existing := get_node_or_null(GENERATED_CONTAINER_NAME) as Node2D
	if existing != null:
		return existing

	var container := Node2D.new()
	container.name = GENERATED_CONTAINER_NAME
	container.set_meta(GENERATED_META_KEY, true)
	add_child(container)
	_set_scene_owner(container)
	return container


func _clear_generated_layers(container: Node2D) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.free()


func _set_scene_owner(node: Node) -> void:
	# Nodes created by a @tool script need an owner or Godot will not save them
	# into the .tscn file.
	var scene_root := get_tree().edited_scene_root
	if scene_root != null:
		node.owner = scene_root


func _unique_node_name(layer_name: String, used_names: Dictionary) -> String:
	var base := layer_name.strip_edges()
	for character in ["/", "\\", ":", ".", "@", "%", "\""]:
		base = base.replace(character, "_")
	if base.is_empty():
		base = "Layer"

	var candidate := base
	var number := 2
	while used_names.has(candidate.to_lower()):
		candidate = "%s_%d" % [base, number]
		number += 1
	used_names[candidate.to_lower()] = true
	return candidate


func _set_status(message: String, is_error: bool = false) -> void:
	status = message
	if is_error:
		push_error("Aseprite Composition: " + message)
	else:
		print("Aseprite Composition: " + message)
