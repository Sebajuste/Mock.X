extends Control


const SQUAD_ITEM_SCENE := preload("res://scenes/ui/squad/SquadItem.tscn")


signal selected(character)


export(NodePath) var squad_path

onready var squad := get_node(squad_path)
onready var members := $MarginContainer/Members


# Called when the node enters the scene tree for the first time.
func _ready():
	
	squad.connect("squad_updated", self, "_on_squad_updated")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_squad_updated():
	for member in squad.team_members:
		var squad_item = SQUAD_ITEM_SCENE.instance()
		squad_item.set_character(member)
		squad_item.connect("selected", self, "_on_selected")
		members.add_child(squad_item)


func _on_selected(character):
	
	emit_signal("selected", character)
	
