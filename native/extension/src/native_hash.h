#ifndef NATIVE_HASH_H
#define NATIVE_HASH_H

#include <godot_cpp/classes/ref_counted.hpp>
#include <cstdint>
#include <cstddef>

namespace godot {

class NativeHash : public RefCounted {
    GDCLASS(NativeHash, RefCounted)

protected:
    static void _bind_methods();

public:
    int64_t hash_string(const String &p_text) const;
    int64_t hash_bytes(const PackedByteArray &p_bytes) const;
    PackedInt64Array hash_strings_batch(const PackedStringArray &p_strings) const;
    bool self_test() const;

private:
    static uint64_t hash_data(const uint8_t *p_data, size_t p_length);
};

}

#endif 
