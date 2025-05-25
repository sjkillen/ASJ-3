from pathlib import Path
from sys import stderr
import bpy
from bpy.types import Object, Armature, Modifier, Mesh, Context, Collection
from functools import reduce, wraps
from operator import attrgetter, itemgetter, or_


def reverted(fn):
    @wraps(fn)
    def inside(*args, **kwargs):
        bpy.ops.wm.save_as_mainfile()
        try:
            fn(*args, **kwargs)
        finally:
            bpy.ops.wm.revert_mainfile()
    return inside


def read_export_path(argv) -> str:
    i = next((i for i, arg in enumerate(argv) if arg == "--export-path"), None)
    if i is None:
        raise Exception(
            "Error getting --export-path argument. This script must be executed from Makefile")
    return str(Path(argv[i+1]).resolve())


def clear_selection(ctx: Context):
    for obj in ctx.selected_objects:
        obj.select_set(False)


def select_collection(ctx: Context, c: Collection):
    for obj in c.objects:
        obj.select_set(True)


def get_ik_limits(armature: Object) -> dict:
    assert type(armature.data) is Armature
    return reduce(or_, ({pbone.name: [
        [pbone.ik_min_x, pbone.ik_max_x],
        [pbone.ik_min_y, pbone.ik_max_y],
        [pbone.ik_min_z, pbone.ik_max_z],
    ]} for pbone in armature.pose.bones
        if pbone.use_ik_limit_x or pbone.use_ik_limit_y or pbone.use_ik_limit_z
    ), dict())

# https://blenderartists.org/t/how-to-apply-all-the-modifiers-with-python/1314483/2


def apply_modifier(obj: Object, modifier: Modifier):
    with bpy.context.temp_override(object=obj, modifier=modifier):
        bpy.context.view_layer.update()
        bpy.ops.object.modifier_apply(modifier=modifier.name)
        bpy.context.view_layer.update()


def sort_uv_layers(mesh: Mesh):
    # UV layers use non-pythonic reference semantics, safest to always reference by their indices
    assert len(
        mesh.uv_layers) <= 7, "There must be fewer than 8 UV maps to sort (one less than the Blender maximum of 8)"
    initial_layers = [[i, layer.name]
                      for i, layer in enumerate(mesh.uv_layers)]
    initial_layers.sort(key=itemgetter(1))
    for i, layer_name in tuple(initial_layers):
        assert mesh.uv_layers[i].name == layer_name, mesh.uv_layers[i].name + \
            " " + layer_name
        mesh.uv_layers.active = mesh.uv_layers[i]
        new_layer = mesh.uv_layers.new(name=f"new_{mesh.uv_layers[i].name}")
        assert new_layer == mesh.uv_layers[-1]
        mesh.uv_layers.active = mesh.uv_layers[0]
        mesh.uv_layers.remove(mesh.uv_layers[i])
        for pair in initial_layers:
            if pair[0] > i:
                pair[0] -= 1
    for layer in mesh.uv_layers:
        layer.name = layer.name.replace("new_", "")
    mesh.uv_layers.active = mesh.uv_layers[0]


def delete_uv_layer(mesh: Mesh, name: str):
    for layer in mesh.uv_layers:
        if layer.name == name:
            mesh.uv_layers.remove(layer)
            return
    raise Exception(f"failed to remove UV layer with name {name}")


def convert_attribute(obj, attribute_name: str):
    "Don't convert this into a function that does multiple at once, indices are too fucky for that"
    for i, attr in enumerate(obj.data.attributes):
        if attr.name == attribute_name:
            obj.data.attributes.active_index = i
            bpy.context.view_layer.update()
            bpy.ops.geometry.attribute_convert(
                mode='VERTEX_GROUP', domain='POINT', data_type='FLOAT')
            bpy.context.view_layer.update()
            return
    raise Exception("attribute not found", attribute_name)



def apply_bone_groups(rig: Armature, skinned: Object):
    """May not be needed in future versions of Blender
    Converts geometry nodes attributes for bone groups back to vertex groups
    Something fishy with indices and attributes, so algorithm is not efficient just to be safe
    """
    with bpy.context.temp_override(object=skinned):
        for bone_name in map(attrgetter("name"), rig.bones):
            for i, attribute in enumerate(skinned.data.attributes):
                if attribute.name == bone_name:
                    skinned.data.attributes.active_index = i
                    bpy.context.view_layer.update()
                    bpy.ops.geometry.attribute_convert(
                        mode='VERTEX_GROUP', domain='POINT', data_type='FLOAT')
                    bpy.context.view_layer.update()
                    break
            else:
                print("Failed to find attribute for", bone_name, file=stderr)

def apply_gn_attr(obj: Object, name: str):
    "See above"
    with bpy.context.temp_override(object=obj):
        for i, attribute in enumerate(obj.data.attributes):
            if attribute.name == name:
                obj.data.attributes.active_index = i
                bpy.context.view_layer.update()
                bpy.ops.geometry.attribute_convert(
                    mode='VERTEX_GROUP', domain='POINT', data_type='FLOAT')
                bpy.context.view_layer.update()
                return
    raise Exception(f"Failed to find attribute: {name}")