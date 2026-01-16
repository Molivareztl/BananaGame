extends MeshInstance3D

func draw(pos1, pos2):
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	mesh.surface_add_vertex(pos1)
	mesh.surface_add_vertex(pos2)
	mesh.surface_end()

func _on_timer_timeout():
	queue_free()
