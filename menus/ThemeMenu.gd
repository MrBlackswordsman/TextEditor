extends MenuButton

onready var main = $"/root/Main"

var popup = null

# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_theme_menu_item_pressed")
	
	populate_theme_menu()
	
	popup.rect_min_size = Vector2(200, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate_theme_menu():
	var dir = Directory.new()
	if dir.dir_exists(main.themes_dir_external):
		print("Found Theme directory.")
	else:
		print("Created Theme directory.")
		dir.make_dir(main.themes_dir_external)
	
	main.themes = App.merge_dictionary(main.get_files_in_directory(main.themes_dir_internal), main.get_files_in_directory(main.themes_dir_external))
	
	for i in main.themes.size():
		var theme_names = main.themes.keys()
		popup.add_check_item(theme_names[i], i)
		
		match popup.get_item_id(i):
			i:
				popup.set_item_checked(i, App.data["Settings"]["Current_Theme"] == popup.get_item_text(i))

func _on_theme_menu_item_pressed(id):
	for i in main.themes.size():
		var list_name = main.themes.keys()
		match id:
			i:
				App.data["Settings"]["Current_Theme"] = popup.get_item_text(i)
				
				$"/root/Main".theme = load(main.themes[list_name[i]])
				popup.set_item_checked(i, (App.data["Settings"]["Current_Theme"] == popup.get_item_text(i)))
		
		for j in popup.get_item_count():
			popup.set_item_checked(j, (App.data["Settings"]["Current_Theme"] == popup.get_item_text(j)))
	
	App.save_data()
