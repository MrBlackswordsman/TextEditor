extends MenuButton

onready var main = $"/root/Main"

var popup = null

# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_format_menu_item_pressed")
	
	populate_format_menu()
	
	popup.rect_min_size = Vector2(200, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate_format_menu():
	for i in App.FORMAT_MENU_OPTIONS:
		popup.add_check_item(i)

func _on_format_menu_item_pressed(id):
	match id:
		0:
			App.data["Settings"]["Enable_Word_Wrap"] = !App.data["Settings"]["Enable_Word_Wrap"]
			main.update_editor()
		1:
			App.data["Settings"]["Show_Line_Numbers"] = !App.data["Settings"]["Show_Line_Numbers"]
			main.update_editor()
	
	popup.set_item_checked(0, App.data["Settings"]["Enable_Word_Wrap"])
	popup.set_item_checked(1, App.data["Settings"]["Show_Line_Numbers"])
