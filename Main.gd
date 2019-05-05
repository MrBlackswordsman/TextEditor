extends Control

onready var open_file_window = $OpenFileDialog
onready var save_file_window = $SaveFileDialog
onready var about_menu_window = $AboutMenuDialog

onready var tabs = $MiddleBar/Tabs
onready var text_edit = $MiddleBar/TextEdit

onready var letter_count = $BottomBar/HBoxContainer/LetterCount
onready var line_count = $BottomBar/HBoxContainer/LineCount

var themes_dir_internal = "res://themes/"
var themes_dir_external = "user://themes/"
var themes = {}

var tab_count_id = 0
var current_tab = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	theme = load(themes[App.data["Settings"]["Current_Theme"]])
	yield(get_tree(), "idle_frame")
	get_tree().connect("files_dropped", self, "_on_files_dropped_into_window")
	
	$CreditsDialog/ScrollContainer.scroll_vertical = 1500
	
	$OpenFileDialog.set_filters(App.FILE_TYPES)
	
	update_editor_tabs()
	update_text_stats()
	
	open_file_window.set_current_dir("/")
	open_file_window.set_current_file("/")
	open_file_window.set_current_path("/")
	
	save_file_window.set_current_dir("/")
	save_file_window.set_current_file("/")
	save_file_window.set_current_path("/")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_files_in_directory(path):
	var files = {}
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	var count = 0
	while true:
		var file = dir.get_next()
		if file == "":
			break
			
		elif not file.begins_with("."):
			var names = file.replace("_", " ").replace(".tres", "")
			files[names] = path+file
			count += 1
	
	dir.list_dir_end()
	
	return files

func new_file():
	tab_count_id += 1
	create_new_tab("Untitled", tab_count_id)
	
	get_node("MiddleBar/"+App.current_files[tab_count_id]).show()
	
	tabs.current_tab = tab_count_id
	update_editor_tabs()

func save_file():
	if $OpenFileDialog.current_file == "":
		save_file_window.popup()
		
	else:
		var file = File.new()
		var text_to_save = get_node("MiddleBar/"+str(App.current_files[current_tab])).text
		var current_file = $OpenFileDialog.current_file
		
		print(str(get_node("MiddleBar/"+str(App.current_files[current_tab])).name))
		
		file.open(str(current_file,".txt"), File.WRITE)
		file.store_string(text_to_save)
		file.close()

func open_file():
	open_file_window.popup()

func menu_shortcut(key):
	var shortcut = ShortCut.new()
	var inputevent = InputEventKey.new()
	
	inputevent.set_scancode(key)
	inputevent.control = true
	
	shortcut.set_shortcut(inputevent)
	return shortcut

func update_editor_tabs():
	if tabs.get_tab_count() == 0:
		if App.current_files.size() <= 0:
			App.current_files[0] = "Untitled"
			create_new_tab(App.current_files[0], tab_count_id)
	else:
		for j in App.current_files.size():
			tabs.set_tab_title(j, App.current_files[j])

func create_new_tab(tab_title, tab_id):
	var new_text_edit = text_edit.duplicate()
	
	App.current_files[tab_id] = tab_title+str(tab_id)
	
	new_text_edit.name = str(App.current_files[tab_id])
	#new_text_edit.rect_size = Vector2(1014, 500)
	
	tabs.add_tab(tab_title)
	$MiddleBar.add_child(new_text_edit)
	new_text_edit.show()
	update_editor()
	update_editor_tabs()
	App.update_window_title(current_tab)

func change_tab(tab_id):
	var new_tab = tab_id
	var current_tab_file = App.current_files[tab_id]
	
	if get_node("MiddleBar/"+App.current_files[current_tab]) != null:
		get_node("MiddleBar/"+App.current_files[current_tab]).hide()
	
	if current_tab_file == "Untitled":
		get_node("MiddleBar/Untitled"+str(new_tab)).show()
	else:
		get_node("MiddleBar/"+current_tab_file).show()
	
	current_tab = tab_id
	update_editor()
	App.update_window_title(current_tab)

func update_editor():
	for i in tabs.get_tab_count():
		for j in $MiddleBar.get_children():
			if j.get_class() == "TextEdit":
				get_node("MiddleBar/"+j.name).show_line_numbers = App.data["Settings"]["Show_Line_Numbers"]
				get_node("MiddleBar/"+j.name).wrap_enabled = App.data["Settings"]["Enable_Word_Wrap"]

func update_text_stats():
	for i in tabs.get_tab_count():
		for j in $MiddleBar.get_children():
			if j.get_class() == "TextEdit":
				letter_count.text = "Characters: " + str(get_node("MiddleBar/"+j.name).text.length())
				line_count.text = "Lines: " + str(get_node("MiddleBar/"+j.name).get_line_count())

func _on_files_dropped_into_window(files, screen):
	var file = File.new()
	if get_node("MiddleBar/"+str(App.current_files[current_tab])).text == "":
		file.open(files[0], 1)
		get_node("MiddleBar/"+str(App.current_files[current_tab])).text = file.get_as_text()
		get_node("MiddleBar/Untitled"+str(current_tab)).name = App.current_file_name
		App.current_file_name = open_file_window.get_current_file().replace(".txt", "")
		App.current_files[current_tab] = App.current_file_name
		file.close()
		
		update_editor()
		update_text_stats()
		App.update_window_title(current_tab)
	else:
		tab_count_id += 1
		file.open(files, 1)
		create_new_tab("Untitled", tab_count_id)
		get_node("MiddleBar/"+str(App.current_files[tab_count_id])).text = file.get_as_text()
		get_node("MiddleBar/Untitled"+str(current_tab)).name = App.current_file_name
		App.current_file_name = open_file_window.get_current_file().replace(".txt", "")
		App.current_files[current_tab] = App.current_file_name
		file.close()

func _on_OpenFileDialog_file_selected(path):
	var file = File.new()
	file.open(path, 1)
	
	get_node("MiddleBar/Untitled"+str(current_tab)).text = file.get_as_text()
	
	App.current_file_name = open_file_window.get_current_file().replace(".txt", "")
	App.current_files[current_tab] = App.current_file_name
	
	file.close()
	
	get_node("MiddleBar/Untitled"+str(current_tab)).name = App.current_file_name
	update_editor_tabs()
	App.update_window_title(current_tab)
	$BottomBar/HBoxContainer/LineCount.text = "Lines: " + str(get_node("MiddleBar/"+str(App.current_file_name)).get_line_count())

func _on_SaveFileDialog_file_selected(path):
	var file = File.new()
	file.open(path, 2)
	file.store_string(get_node("MiddleBar/Untitled"+str(current_tab)).text)
	file.close()

func _on_NewTabButton_pressed():
	tab_count_id += 1
	create_new_tab("Untitled", tab_count_id)
	
	get_node("MiddleBar/"+App.current_files[tab_count_id]).show()
	
	tabs.current_tab = tab_count_id
	update_editor_tabs()

func _on_Tabs_tab_clicked(tab):
	change_tab(tab)

func _on_Tabs_tab_hover(tab):
	current_tab = tabs.get_current_tab()

func _on_Tabs_tab_changed(tab):
	update_text_stats()
	App.update_window_title(current_tab)

func _on_Tabs_tab_close(tab):
	if tab_count_id == 0:
		get_node("MiddleBar/Untitled"+str(tab_count_id)).select_all()
		get_node("MiddleBar/Untitled"+str(tab_count_id)).cut()
		
	else:
		get_node("MiddleBar/"+str(App.current_files[tab])).queue_free()
		App.current_files.erase(tab)
		tabs.remove_tab(tab)
		tab_count_id -= 1
		
		get_node("MiddleBar/"+App.current_files[tab_count_id]).show()

func _on_TextEdit_text_changed():
	update_text_stats()

func _on_CreditsButton_pressed():
	$CreditsDialog.popup()
