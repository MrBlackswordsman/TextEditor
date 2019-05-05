extends MenuButton

onready var main = $"/root/Main"

var popup = null

# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_edit_menu_item_pressed")
	
	populate_edit_menu()
	
	popup.rect_min_size = Vector2(200, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate_edit_menu():
	for i in App.EDIT_MENU_OPTIONS:
		popup.add_item(i)
	
	popup.set_item_as_separator(3, true)
	popup.set_item_as_separator(6, true)

func _on_edit_menu_item_pressed(id):
	match id:
		0:
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).cut()
		1:
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).copy()
		2:
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).paste()
		4:
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).select_all()
		5:
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).select_all()
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).cut()
		7:
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).undo()
		8:
			get_node("/root/Main/MiddleBar/Untitled"+str(main.tabs.get_current_tab())).redo()
