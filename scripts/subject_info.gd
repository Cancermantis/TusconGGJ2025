extends Resource
class_name SubjectInfo

# Simple resource describing a potential photography subject

@export var name: String
# If a photo subject of this type is further than this distance, 
# it won't be considered a subject of the current photo
@export var cull_distance: float = 8.0
@export var description: String #could be used for tooltips
