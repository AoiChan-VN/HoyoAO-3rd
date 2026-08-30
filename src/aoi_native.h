#ifndef AOI_NATIVE_H
#define AOI_NATIVE_H

#include <godot_cpp/classes/ref_counted.hpp>

namespace godot {

class AoiNative : public RefCounted {
    GDCLASS(AoiNative, RefCounted);

protected:
    static void _bind_methods() {}

public:
    AoiNative() = default;
    ~AoiNative() = default;
};

}

#endif
