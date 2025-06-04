@tool
extends EditorScenePostImport


func _post_import(scene: Node) -> Object:
	var tree_spawner: Node3D = scene.get_node("TreeSpawner")
	var trees := Node3D.new()
	scene.add_child(trees)
	trees.owner = scene
	var i := 0
	for child in tree_spawner.get_children():
		var new_tree := preload("res://tree.tscn").instantiate()
		new_tree.transform = child.transform
		new_tree.name = "tree_" + str(i)
		i += 1
		trees.add_child(new_tree)
		new_tree.owner = scene
	scene.remove_child(tree_spawner)
	tree_spawner.queue_free()
	return scene
