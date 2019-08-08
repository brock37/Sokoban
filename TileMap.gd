extends TileMap

enum {EMPTY,  BOX, BOX_CHECK, OBJECTIVE, WALL, PLAYER}

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2
var grid_size = Vector2()
 
var grid = []
onready var Player = preload("res://Player.tscn")
onready var Obstacle = preload("res://Obstacle.tscn")
onready var Box = preload("res://Box.tscn")
var player_start_pos = Vector2(1,1)

func _ready():
	randomize()
	grid_size= Vector2(cell_quadrant_size, cell_quadrant_size)
	#Make an EMPTY grid
	for x in range (grid_size.x) :
		grid.append([])
		for y in range (grid_size.y) :
			grid[x].append(get_cell(x,y))
#	#Player
	var new_player= Player.instance()
	new_player.position = map_to_world(player_start_pos) + half_tile_size
	grid[player_start_pos.x][player_start_pos.y] = PLAYER
	add_child(new_player)
	
#	#Box
	var new_box = Box.instance()
	var pos =Vector2(1,2)
	new_box.position = map_to_world( pos) + half_tile_size
	grid[pos.x][pos.y] = BOX
	add_child(new_box)
	
	print_grid()
	
	
	get_node("Player").connect("hit", self, "_collided")
	
func _collided(pos, dir):
	print("HIT")
	print(pos)
	print(cell_type(pos))
	if cell_type(pos) == BOX:
		#update_child_pos(pos, dir, BOX)
		print("box")
		

	
func is_cell_vacant(origin_grid_pos= Vector2(), direction=Vector2() ):
	var target_grid_pos = world_to_map(origin_grid_pos) + direction
	
	#check target is in the grid
	if target_grid_pos.x >= 0 and target_grid_pos.x < grid_size.x :
		if target_grid_pos.y >= 0 and target_grid_pos.y < grid_size.y :
			#grid return true if the cell is empty
			if grid[target_grid_pos.x][target_grid_pos.y] == -1 or grid[target_grid_pos.x][target_grid_pos.y] == 3 :
				return true 
			else :
				return false
	return false
	
func cell_type(this_world_position= Vector2()):
	var pos = world_to_map(this_world_position)
	print(pos)
	return grid[pos.x][pos.y]
	
#upadte_child_node
#resume : clean the old position of the grid ( fill it with EMPTY)
# and change with type of the new position in the grid
# then return the position in pixel 
#
func update_child_pos(this_world_pos, direction, type):
	var this_grid_pos = world_to_map(this_world_pos)
	var new_grid_pos = this_grid_pos + direction
	
	#remove type from current location
	grid[this_grid_pos.x][this_grid_pos.y] = EMPTY
	
	#place child type in new grid location
	grid[new_grid_pos.x][new_grid_pos.y] = type
	
	var new_world_pos= map_to_world( new_grid_pos) + half_tile_size
	print_grid()
	return new_world_pos
	
	
func print_grid():
	for n in range (grid_size.x) :
		print(grid[n])
	print("\n")
	
	
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
		

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
