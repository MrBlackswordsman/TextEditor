extends MenuButton

onready var main = $"/root/Main"

var popop = null

# Called when the node enters the scene tree for the first time.
func _ready():
	popop = get_popup()
	popop.connect("id_pressed", self, "_on_about_help_item_pressed")
	
	populate_help_menu()
	
	popop.rect_min_size = Vector2(200, 30)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate_help_menu():
	popop.add_item("About", 0)

func _on_about_help_item_pressed(id):
	match id:
		0:
			get_node("/root/Main/AboutMenuDialog").popup()