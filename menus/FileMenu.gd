extends MenuButton

onready var main = $"/root/Main"

var popup = null

# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_file_menu_item_pressed")
	
	populate_file_menu()
	
	popup.rect_min_size = Vector2(200, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate_file_menu():
	for i in App.FILE_MENU_OPTIONS:
		popup.add_item(i)
	
	popup.set_item_as_separator(2, true)
	popup.set_item_as_separator(5, true)

func _on_file_menu_item_pressed(id):
	match id:
		0:
			main.new_file()
		1:
			main.open_file_window.popup()
		3:
			main.save_file()
		4:
			main.save_file_window.popup()
		6:
			get_tree().quit()