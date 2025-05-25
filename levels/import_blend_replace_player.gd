@tool
extends EditorScenePostImport


func _post_import(scene: Node) -> Object:
	var wl := [scene]
	while wl.size() !=0:
		var node: Node = wl.pop_front()
		var children := node.get_children()
		if node.name == "player":
			var new_node := preload("res://player.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			for child in children:
				node.remove_child(child)
				new_node.add_child(child)
			node.get_parent().add_child(new_node)
			new_node.owner = scene
			node.get_parent().remove_child(node)
			node.free()
			node = new_node
			node.name = "player"
		wl.append_array(children)
	return scene
