#include "register_types.h"
#include "native_hash.h"

#include <godot_cpp/godot.hpp>

using namespace godot;

void initialize_native_extension_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_CORE) {
        return;
    }

    ClassDB::register_internal_class<NativeHash>(p_level);
}

void uninitialize_native_extension_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_CORE) {
        return;
    }
}

extern "C" {

GDExtensionBool GDE_EXPORT native_hash_extension_init(
    GDExtensionInterfaceGetProcAddress p_get_proc_address,
    GDExtensionClassLibraryPtr p_library,
    GDExtensionInitialization *r_initialization
) {
    GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

    init_obj.register_initializer(initialize_native_extension_module);
    init_obj.register_terminator(uninitialize_native_extension_module);

    return init_obj.init();
}

} 
