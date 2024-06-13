extends Node3D

var default_priority : int
@onready var phantom_camera_3d = get_all_children(self,"ThirdPersonCamera")[0]
@onready var camerahost :PhantomCameraHost= get_tree().get_first_node_in_group("GameHolderCamera")

func get_all_children(node, group = ""):
	var all_children = []
	for i in node.get_children():
		all_children.append(i)
		all_children += get_all_children(i)
	if group != "":
		for i in all_children:
			if !i.is_in_group(group):
				all_children.erase(i)
	return all_children

var has_had_input := false
var direction : Vector2 = Vector2.ZERO
var direction_radians :
	get:
		return camerahost._active_pcam_3d_glob_transform.basis.get_euler().y

func _ready():
	## Set the backup priority.
	if default_priority == null:
		default_priority = phantom_camera_3d.priority

func _process(delta):
	get_camera_direction(delta)
	if has_had_input:
		var old = phantom_camera_3d.get_third_person_rotation_degrees()
		phantom_camera_3d.set_third_person_rotation_degrees( Vector3(clampf(old.x+direction.x,-85,45), old.y+direction.y, old.z))
	else:
		phantom_camera_3d.set_third_person_rotation_degrees(Vector3(0,0,0))

## Contains the rotation angle for the spawn point or other objects if desired.
var on_load_rotation := 0.0
func on_load_camera_rotate(vector):
	on_load_rotation = vector
	phantom_camera_3d.set_third_person_rotation_degrees(Vector3(0,on_load_rotation,0))

func get_camera_direction(delta):
	direction.x = Input.get_axis("camera_down","camera_up")
	direction.y = Input.get_axis("camera_right", "camera_left")
	
	if direction.length() > 1:
		direction = direction.normalized()
	direction *= 250*delta
	
	direction.x -= mouse_input.y*.1
	direction.y -= mouse_input.x*.1
	mouse_input = Vector2.ZERO
	
	if direction.length() > 0:
		has_had_input = true

var mouse_input :Vector2
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var viewport_transform : Transform2D = get_tree().root.get_final_transform()
		mouse_input += event.xformed_by(viewport_transform).relative
