extends Node3D
class_name Rope

@export var o_path : NodePath
@export var o_pos : Vector3 = Vector3.ZERO

@export var t_path : NodePath
@export var t_pos : Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
    var origin_position = Vector3.ZERO
    if o_path != null:
        var o_node = get_node_or_null(o_path)
        if o_node != null:
            origin_position = self.to_local(o_node.to_global(o_pos))
    
    var terminal_position = Vector3.ZERO
    if t_path != null:
        var t_node = get_node_or_null(t_path)
        if t_node != null:
            terminal_position = self.to_local(t_node.to_global(t_pos))
    
    var p = Path3D.new()
    var c = Curve3D.new()
    if origin_position.distance_to(terminal_position) != 0:
        c.add_point(origin_position)
        c.add_point(terminal_position)
    p.curve = c
    self.add_child(p)
    $CSGPolygon3D["path_node"] = p.get_path()

func set_origin(parent: Node3D, anchor: Vector3 = Vector3.ZERO) -> void:
    o_path = parent.get_path()
    o_pos = anchor

func set_terminal(parent: Node3D, anchor: Vector3 = Vector3.ZERO) -> void:
    t_path = parent.get_path()
    t_pos = anchor
