class_name InputAction
extends RefCounted

enum Action {
    MOVE,
    LOOK,
    ATTACK,
    DODGE,
    SKILL_1,
    SKILL_2,
    ULTIMATE,
    INTERACT,
    MENU,
    COUNT
}

static func get_name(action_id: int) -> String:
    match action_id:
        Action.MOVE:
            return "MOVE"
        Action.LOOK:
            return "LOOK"
        Action.ATTACK:
            return "ATTACK"
        Action.DODGE:
            return "DODGE"
        Action.SKILL_1:
            return "SKILL_1"
        Action.SKILL_2:
            return "SKILL_2"
        Action.ULTIMATE:
            return "ULTIMATE"
        Action.INTERACT:
            return "INTERACT"
        Action.MENU:
            return "MENU"

    return "UNKNOWN" 
