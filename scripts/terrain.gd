extends StaticBody3D

@onready var shape: CollisionShape3D = $CollisionShape3D
@onready var geometry: MeshInstance3D = $CollisionShape3D/Terrain/world/geometry_0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arrays := geometry.mesh.get_faces()
	(shape.shape as ConcavePolygonShape3D).set_faces(arrays)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
