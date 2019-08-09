extends TileMap

enum {EMPTY,  BOX, BOX_CHECK, OBJECTIVE, WALL, PLAYER}

var parent
var canvas

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2
var grid_size = Vector2()
 
#var grid = []
var objectives_position = []
var objectives 

onready var Player = preload("res://Player.tscn")
onready var Obstacle = preload("res://Obstacle.tscn")
onready var Box = preload("res://Box.tscn")

var player_start_pos = Vector2(1,1)

var actual_world = 1
var actual_level = 1

func _ready():
	parent= get_parent()
	canvas= parent.get_node("CanvasLayer")
	randomize()
	grid_size= Vector2(cell_quadrant_size, cell_quadrant_size)
	#Put the tile into the grid
#	for x in range (grid_size.x) :
#		grid.append([])
#		for y in range (grid_size.y) :
#			grid[x].append(get_cell(x,y))
			

#	#Player
	var new_player= Player.instance()
	add_child(new_player)
	
	#board
	load_level(actual_world, actual_level)
	
	print_grid()
	
	
	get_node("Player").connect("hit", self, "_collided")
	canvas.connect("restart_level", self, "_restart_level")
	canvas.connect("next_level", self, "_next_level")
	
	
func _process(delta):
	if objectives == 0 :
		canvas.show_level_complete()
		set_process(false)


func _unhandled_input(event):
	if event is InputEventKey :
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
		elif event.pressed and event.scancode == KEY_S:
			write_file(print_grid(), "res://level/level1_1.dat")
			canvas.show_message("Write file")
		elif event.pressed and event.scancode == KEY_R:
			_restart_level()
	
	
	
func _collided(pos, dir):
	print("Collied" + " (" + str(pos.x) + "," + str(pos.y) + ")")
	print("Type: " + str(cell_type(pos)))
	
	if cell_type(pos) == BOX or cell_type(pos) == BOX_CHECK:
		#update_child_pos(pos, dir, BOX)
		update_tile_map(pos, dir, BOX)
		print("box")
		


func cell_type(this_world_position= Vector2()):
	var pos = world_to_map(this_world_position)
	print(pos)
	return get_cell(pos.x,pos.y)
	

	
func update_tile_map(pos, dir, type) :
	var map_pos = world_to_map(pos)
	var new_map_pos = map_pos + dir
	
	if get_cellv(new_map_pos) != BOX and get_cellv(new_map_pos) !=BOX_CHECK and get_cellv(new_map_pos) != WALL:
		#clear location  in tile map
		for i in objectives_position:
			if Vector2(map_pos.x, map_pos.y) == i :
				set_cellv(map_pos, OBJECTIVE)
				objectives += 1
				break
			else :
				set_cellv(map_pos, EMPTY)
	
		#set up type in the new location
		if get_cellv(new_map_pos) == OBJECTIVE :
			set_cellv(new_map_pos, BOX_CHECK)
			objectives -= 1
		else :
			set_cellv(new_map_pos, BOX)
	print_grid()
		#update_child_pos(pos, dir, type)
		


func _restart_level():
	load_level(actual_world, actual_level)
	


func _next_level():
	actual_level += 1
	load_level(actual_world, actual_level)


func load_level(world, level) :
	objectives = 0
	#Load level form file
	var world_level= str(world) + "_" + str(level)
	var map= load_file("res://level/level" + world_level +".dat")
	print(map)
	print("\n\n _______________")
	
	for x in range (grid_size.x):
		for y in range (grid_size.y):
			var type =map[ x + y * grid_size.y]
			print("type: " + type)
			if  int(type) == PLAYER:
				#Place player on map
				player_start_pos = Vector2(x,y)
				get_node("Player").position = map_to_world(player_start_pos) + half_tile_size
				set_cell(x,y, EMPTY)
			else :
				set_cell(x,y, int(type))
				
	#Save objectives position
	for x in range (grid_size.x):
		for y in range (grid_size.y):
			if get_cell(x,y) == OBJECTIVE:
				objectives_position.append(Vector2(x,y))
				objectives += 1
				
	set_process(true)



func load_file(path):
	var file = File.new()
	file.open(path, file.READ)
	var content = file.get_as_text()
	file.close()
	return content



func write_file(content, path):
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_string(content)
	file.close()



func print_grid():
#	for n in range (grid_size.x) :
#		print(grid[n])
#	print("\n")
	var line = ""
	for x in range (grid_size.x) :
		for y in range (grid_size.y) :
			line += str(get_cell(y,x))
		line += "\n"
	print(line)
	return line
	
	
#func _ready():
#	randomize()
#	grid_size= Vector2(cell_quadrant_size, cell_quadrant_size)
#	#Make an EMPTY grid
#	for x in range (grid_size.x) :
#		grid.append([])
#		for y in range (grid_size.y) :
#			grid[x].append(EMPTY)
#
#	#Player
#	var new_player= Player.instance()
#	new_player.position = map_to_world(player_start_pos) + half_tile_size
#	grid[player_start_pos.x][player_start_pos.y] = PLAYER
#	add_child(new_player)
#
#	#Box
#	var new_box = Box.instance()
#	var pos =Vector2(randi() % int(grid_size.x) , randi() % int(grid_size.y))
#	new_box.position = map_to_world( pos) + half_tile_size
#	grid[pos.x][pos.y] = BOX
#	add_child(new_box)
#
#	#Obstacle
#	var positions = []
#	for n in range (5) :
#		var placed = false
#		while not placed :
#			var grid_pos = Vector2(randi() % int(grid_size.x) , randi() % int(grid_size.y))
#			if not grid[grid_pos.x][grid_pos.y] :
#				if not grid_pos in positions :
#					positions.append(grid_pos)
#					placed = true
#
#	for pos in positions :
#		var new_obstacle = Obstacle.instance()
#		new_obstacle.position = map_to_world( pos) + half_tile_size
#		grid[pos.x][pos.y] = WALL
#		add_child(new_obstacle)

#func is_cell_vacant(origin_grid_pos= Vector2(), direction=Vector2() ):
#	var target_grid_pos = world_to_map(origin_grid_pos) + direction
#
#	#check target is in the grid
#	if target_grid_pos.x >= 0 and target_grid_pos.x < grid_size.x :
#		if target_grid_pos.y >= 0 and target_grid_pos.y < grid_size.y :
#			#grid return true if the cell is empty
#			if grid[target_grid_pos.x][target_grid_pos.y] == -1 or grid[target_grid_pos.x][target_grid_pos.y] == 3 :
#				return true 
#			else :
#				return false
#	return false

#upadte_child_node
#resume : clean the old position of the grid ( fill it with EMPTY)
# and change with type of the new position in the grid
# then return the position in pixel 
#
#func update_child_pos(this_world_pos, direction, type):
#	var this_grid_pos = world_to_map(this_world_pos)
#	var new_grid_pos = this_grid_pos + direction
#
#	#remove type from current location
#	grid[this_grid_pos.x][this_grid_pos.y] = EMPTY
#
#	#place child type in new grid location
#	grid[new_grid_pos.x][new_grid_pos.y] = type
#
#	var new_world_pos= map_to_world( new_grid_pos) + half_tile_size
#	print_grid()
#	return new_world_pos
