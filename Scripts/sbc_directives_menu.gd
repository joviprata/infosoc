@tool
class_name SBC_Directive_Menu extends Control

@export var vertical_box: VBoxContainer

var SBC_DIRECTIVE = load("res://Scenes/ui/sbc_directive.tscn")

var currentDirectives : Dictionary[StringName,String] = {}

@export_tool_button("Set SBC Directives", 'Callable') var set_dirs = set_directives
func set_directives() -> void:
	currentDirectives.assign(Global.SBC_DIRECTIVES)
	for directive in currentDirectives.keys():
		var desc = currentDirectives[directive]
		var direct : SBC_Directive = SBC_DIRECTIVE.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		var text = "<color=blue>{num}</color> - {description}".format({'num':directive, 'description':desc})
		
		direct.text_area.text = text
		direct.name = "SBC_DIRECTIVE-" + directive
		vertical_box.add_child(direct)
		
	
