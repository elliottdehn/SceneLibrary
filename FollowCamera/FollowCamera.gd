extends Node3D

@export var target: Node3D
@export var mouse_sensitivity = 0.2
@export var margin = 0.5
@export var follow_distance = 3.0

var target_camera_position = Vector3(0, 0, follow_distance)

func _ready():
  top_level = true
  set_physics_process(true)
  
func _physics_process(delta):
  # center the pivot on the target
  global_position = target.global_position
  
  # get a baseline target position for the camera that is follow_distance units away
  var camera_position = Vector3(0, 0, follow_distance)
  
  if $Ray.is_colliding():
    var hit = $Ray.get_collision_point()
    var normal = $Ray.get_collision_normal()
    var towards_target = hit.direction_to(target.global_position)
    var angle = normal.angle_to(towards_target)
    var desired_distance_from_hit = margin / cos(angle)
    var adjusted_position = hit + towards_target * desired_distance_from_hit
    var adjusted_distance = adjusted_position.distance_to(target.global_position)
    if (adjusted_distance < follow_distance):
      camera_position = to_local(adjusted_position)
    
  # set the camera position to the new position calculated
  target_camera_position = camera_position
  
  # Move the camera towards the target position.
  $Camera.position = $Camera.position.lerp(target_camera_position, delta * 15.0)
  
  # point the camera at the target.
  $Camera.look_at(target.global_position)
    
  
func _unhandled_input(event):
  if event is InputEventMouseMotion:
    rotation_degrees.y -= event.relative.x * mouse_sensitivity
    rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

    rotation_degrees.x -= event.relative.y * mouse_sensitivity
    rotation_degrees.x = clamp(rotation_degrees.x, -85.0, 30.0)
