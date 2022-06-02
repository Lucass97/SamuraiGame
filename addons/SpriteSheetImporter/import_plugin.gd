tool
extends EditorImportPlugin

enum Preset { PRESET_DEFAULT }

func get_importer_name():
	return "snkkid.SpriteSheetImporter"

func get_visible_name():
	return "Sprite sheet importer"

func get_recognized_extensions():
	return ["json"]

func get_save_extension():
	return "res"

func get_resource_type():
	return "Resource"
	
func get_preset_count():
	return Preset.size()

func get_preset_name(preset):
	match preset:
		PRESET_DEFAULT: return "Default"

func get_import_options(preset):
	match preset:
		PRESET_DEFAULT:
			return [{
					"name": "Import_As_Atlas",
					"default_value": true
					}]
		_:
			return []

func get_option_visibility(option, options):
	return true

func get_import_order():
	return 200

func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	print("Importing sprite sheet from "+source_file);
	
	var sheets = read_sprite_sheet(source_file)
	if typeof(sheets) == TYPE_INT:
		return sheets
	
	if options.Import_As_Atlas:
		var sheetFolder = source_file.get_basename()+".sprites";
		var err = create_folder(sheetFolder)
		if typeof(err) == TYPE_INT:
			return 1
	
		var image = ImageTexture.new()
		image = load(source_file.get_base_dir().plus_file(sheets.meta.image))

		for sheet in sheets.frames:
			var texture = AtlasTexture.new()
			texture.atlas = image
			var name = sheetFolder+"/"+sheet.filename.get_basename()+".tres"
			texture.region = Rect2(sheet.frame.x,sheet.frame.y,sheet.frame.w,sheet.frame.h)
			save_resource(name, texture)
		
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], Resource.new())
	
func save_resource(name, texture):
	create_folder(name.get_base_dir())
	
	var status = ResourceSaver.save(name, texture)
	if status != OK:
		printerr("Failed to save resource "+name)
		return false
	return true

func read_sprite_sheet(fileName):
	var nbError = 0
	var file = File.new()
	if file.open(fileName, file.READ) != OK:
		printerr("Failed to load "+fileName)
		return 1
	var text = file.get_as_text()
	var dict = JSON.parse(text).result
	file.close()	
	
	if !dict:
		nbError = nbError + 1
	if !dict.has("meta"):
		nbError = nbError + 1
	if !dict.meta.has("image"):
		nbError = nbError + 1
	if !dict.has("frames"):
		nbError = nbError + 1
	if dict.frames.size() == 0:
		nbError = nbError + 1
	if !dict.frames[0].has("filename"):
		nbError = nbError + 1
	if !dict.frames[0].has("frame"):
		nbError = nbError + 1
	if !dict.frames[0].frame.has("x"):
		nbError = nbError + 1
	if !dict.frames[0].frame.has("y"):
		nbError = nbError + 1
	if !dict.frames[0].frame.has("w"):
		nbError = nbError + 1
	if !dict.frames[0].frame.has("h"):
		nbError = nbError + 1
	
	if nbError > 0:
		printerr("Invalid json data in "+fileName)
		return nbError
	
	return dict

func create_folder(folder):
	var dir = Directory.new()
	if !dir.dir_exists(folder):
		if dir.make_dir_recursive(folder) != OK:
			printerr("Failed to create folder: " + folder)
			return 1