extends Node

var app_name = "TextEdit"
var current_files = {}
var current_file_name = ""

const FILE_MENU_OPTIONS = ["New","Open", "", "Save","Save As", "", "Exit"]
const EDIT_MENU_OPTIONS = ["Cut", "Copy", "Paste", "", "Select All", "Clear", "", "Undo", "Redo"]
const OPTIONS_MENU_OPTIONS = ["Fullscreen", "Maximize Window", "Always On Top", "Keep Screen On", "", "Show Line Numbers","Enable Word Wrap"]

const FILE_TYPES = PoolStringArray(["*.txt ; Text Document","*.html ; Hyper Text Markup Lang.", "*.css ; Cascading Style Sheets", "*.php : PHP: Hypertext Preprocessor"])

const CONFIG_FILE = "user://config.cfg" 

var config_file = ConfigFile.new()

var data = {
	"Settings": {
		"Fullscreen": false,
		"Maximized": false,
		"Always_on_Top": false,
		"Keep_Screen_On": false,
		"Show_Line_Numbers": false,
		"Enable_Word_Wrap": false,
		"Current_Theme": "White Theme"
		}
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	var file2Check = File.new()
	if not file2Check.file_exists(CONFIG_FILE):
		save_data()
	
	update_window_title(0)
	load_settings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func merge_dictionary(dict_1, dict_2):
	for key in dict_2:
		dict_1[key] = dict_2[key]
	
	return dict_1

func update_window_title(tab_id):
	if current_files.size() <= 0:
		OS.set_window_title(app_name + " | " + "Untitled")
		
	else:
		OS.set_window_title(app_name + " | " + str(current_files[tab_id]))

func save_data():
	for section in data.keys():
		for key in data[section].keys():
			config_file.set_value(section, key, data[section][key])
	
	config_file.save(CONFIG_FILE)

func load_data():
	var error = config_file.load(CONFIG_FILE)
	if error != OK:
		print("Error loading the Config File...")
		save_data()
		print("Created new Config file.")
		return
	
	for section in data.keys():
		for key in data[section].keys():
			data[section][key] = config_file.get_value(section, key)

func load_settings():
	load_data()
	
	OS.window_fullscreen = data["Settings"]["Fullscreen"]
	OS.window_maximized = data["Settings"]["Maximized"]
	OS.set_window_always_on_top(data["Settings"]["Always_on_Top"])
	OS.keep_screen_on = data["Settings"]["Keep_Screen_On"]