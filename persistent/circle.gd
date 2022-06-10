extends RigidBody2D

export(int) var test = 5

func save():
	return {
		"filename": filename,
		"parent": get_parent().get_path(),
		"position": var2str(position),
		"modulate": var2str(modulate),
		"test": test
	}
