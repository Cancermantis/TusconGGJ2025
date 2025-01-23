extends Resource
class_name SubjectInfo

# Simple resource describing a potential photography subject

@export var name: String
#maximum distance that the subject candidate can be visible, onoccluded, and still considered a subject of the photo
@export var max_distance: float = 8.0
@export var description: String #could be used for tooltips
