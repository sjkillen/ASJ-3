import bpy
from bpy.types import Panel, Context, Operator, StretchToConstraint, KinematicConstraint, Constraint
from typing import Iterable
from itertools import chain

RIG_NAME = "SlimePigRig"

bottom_leg_bones = (
    "leg_front_bottom.L",
    "leg_front_bottom.R",
    "leg_back_bottom.L",
    "leg_back_bottom.R",
)


def bone_constraints(bone_name: str) -> Iterable[Constraint]:
    return bpy.data.objects[RIG_NAME].pose.bones[bone_name].constraints


def set_constraint_type(bone_name: str, constraintType: type, enable: bool):
    for constraint in bone_constraints(bone_name):
        if isinstance(constraint, constraintType):
            constraint.enabled = enable


def make_constraint_operators(bones: Iterable[str], constraintType: type):
    class Enable(Operator):
        bl_idname = f"object.enable_{constraintType.__name__.lower()}"
        bl_label = f"Enable{constraintType.__name__}"
        constraint = constraintType

        def execute(self, ctx: Context):
            for bone in bones:
                set_constraint_type(bone, constraintType, enable=True)
            return {"FINISHED"}

    class Disable(Operator):
        bl_idname = f"object.disable_{constraintType.__name__.lower()}"
        bl_label = f"Disable{constraintType.__name__}"
        constraint = constraintType

        def execute(self, ctx: Context):
            for bone in bones:
                set_constraint_type(bone, constraintType, enable=False)
            return {"FINISHED"}
    return Enable, Disable


constraint_operators = tuple(make_constraint_operators(bottom_leg_bones, constraintType)
                             for constraintType in (StretchToConstraint, KinematicConstraint))


class UI(Panel):
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = 'Item'
    bl_label = "Rig Controls"
    bl_idname = "slimepig_UI"

    def draw(self, ctx: Context):
        for enable, disable in constraint_operators:
            self.layout.label(text=f"{enable.constraint.__name__}s")
            row = self.layout.row()
            row.operator(enable.bl_idname, text="Enable")
            row.operator(disable.bl_idname, text="Disable")


register, unregister = bpy.utils.register_classes_factory(
    (UI, *chain.from_iterable(constraint_operators)))

# class BLOP_PT_riguilayers(bpy.types.Panel):
#     bl_space_type = 'VIEW_3D'
#     bl_region_type = 'UI'
#     bl_category = 'Item'
#     bl_label = "Rig Layers"
#     bl_idname = "BLOP_PT_riguilayers"

#     @classmethod
#     def poll(self, context):
#         try:
#             return (context.active_object.data.get("blm_rig_id") == blm_rig_id)
#         except (AttributeError, KeyError, TypeError):
#             return False

#     def draw(self, context):
#         layout = self.layout
#         col = layout.column()
#         collection = bpy.data.armatures["Squirrel-Armature"].collections

# ### blender4.x #####
#         row = col.row()
#         row.prop(collection["Layer 9 - ROOT"],'is_visible', toggle=True, text='ROOT')

#         row = col.row()
#         row.prop(collection["Layer 10 - MAIN"],'is_visible', toggle=True, text='MAIN')
#         row.prop(collection["Layer 11 - TWEAK"],'is_visible', toggle=True, text='TWEAK')

# class BLOP_PT_riguiproperties(bpy.types.Panel):
#     bl_space_type = 'VIEW_3D'
#     bl_region_type = 'UI'
#     bl_category = 'Item'
#     bl_label = "Rig properties"
#     bl_idname = "BLOP_PT_riguiproperties"

#     @classmethod
#     def poll(self, context):
#         try:
#             return (context.active_object.data.get("blm_rig_id") == blm_rig_id)
#         except (AttributeError, KeyError, TypeError):
#             return False

#     def draw(self, context):
#         layout = self.layout
#         col = layout.column()

#         # get armature and "PROPERTIES" bone
#         arm = context.active_object
#         bone = arm.pose.bones["PROPERTIES"]

#         # basic layout setup
#         layout = self.layout
#         # just in we case want to change the split makes make a variable
#         split_size = 0.7

#         # then we start making rows
#         box = layout.box()
#         col = box.column(align=True)
#         row = col.row()
#         split = row.split(align=True, factor=split_size)
#         row = split.row(align=True)
#         # this is just the label you could call it anything
#         row.label(text='Tail follow', translate=False)
#         row = split.row(align=True)
#         # this is the property > format is important
#         row.prop(bone, '["TAIL-FOLLOW"]', text = "", slider=True)

#         # copy paste repeat... test as you go
#         box = layout.box()
#         col = box.column(align=True)
#         row = col.row()
#         split = row.split(align=True, factor=split_size)
#         row = split.row(align=True)
#         row.label(text='Hide legs', translate=False)
#         row = split.row(align=True)
#         row.prop(bone, '["hide-legs"]', text = "", slider=True)
#         row = col.row()
#         split = row.split(align=True, factor=split_size)
#         row = split.row(align=True)
#         row.label(text='Hide tail', translate=False)
#         row = split.row(align=True)
#         row.prop(bone, '["hide-tail"]', text = "", slider=True)
