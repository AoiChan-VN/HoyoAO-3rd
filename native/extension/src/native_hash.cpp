#include "native_hash.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>
#include <godot_cpp/variant/packed_int64_array.hpp>
#include <godot_cpp/variant/packed_string_array.hpp>
#include <godot_cpp/variant/string.hpp>

using namespace godot;

static const uint64_t FNV_OFFSET_64 = 14695981039346656037ULL;
static const uint64_t FNV_PRIME_64 = 1099511628211ULL;

uint64_t NativeHash::hash_data(const uint8_t *p_data, size_t p_length) {
    uint64_t hash = FNV_OFFSET_64;

    for (size_t i = 0; i < p_length; ++i) {
        hash ^= static_cast<uint64_t>(p_data[i]);
        hash *= FNV_PRIME_64;
    }

    return hash;
}

int64_t NativeHash::hash_string(const String &p_text) const {
    CharString utf8 = p_text.utf8();
    const uint8_t *data = reinterpret_cast<const uint8_t *>(utf8.get_data());
    return static_cast<int64_t>(hash_data(data, static_cast<size_t>(utf8.length())));
}

int64_t NativeHash::hash_bytes(const PackedByteArray &p_bytes) const {
    const uint8_t *data = p_bytes.ptr();
    return static_cast<int64_t>(hash_data(data, static_cast<size_t>(p_bytes.size())));
}

PackedInt64Array NativeHash::hash_strings_batch(const PackedStringArray &p_strings) const {
    PackedInt64Array result;
    int64_t count = p_strings.size();

    for (int64_t i = 0; i < count; ++i) {
        result.append(hash_string(p_strings[i]));
    }

    return result;
}

bool NativeHash::self_test() const {
    static const uint8_t test_a[1] = { 97 };

    uint64_t empty_hash = hash_data(nullptr, 0);
    uint64_t a_hash = hash_data(test_a, 1);

    if (empty_hash != 0xcbf29ce484222325ULL) {
        return false;
    }

    if (a_hash != 0xaf63dc4c8601ec8cULL) {
        return false;
    }

    if (hash_string("") != static_cast<int64_t>(empty_hash)) {
        return false;
    }

    if (hash_string("a") != static_cast<int64_t>(a_hash)) {
        return false;
    }

    PackedByteArray bytes;
    bytes.append(97);

    if (hash_bytes(bytes) != static_cast<int64_t>(a_hash)) {
        return false;
    }

    PackedStringArray strings;
    strings.append("a");
    strings.append("b");

    PackedInt64Array batch = hash_strings_batch(strings);
    return batch.size() == 2;
}

void NativeHash::_bind_methods() {
    ClassDB::bind_method(D_METHOD("hash_string", "text"), &NativeHash::hash_string);
    ClassDB::bind_method(D_METHOD("hash_bytes", "bytes"), &NativeHash::hash_bytes);
    ClassDB::bind_method(D_METHOD("hash_strings_batch", "strings"), &NativeHash::hash_strings_batch);
    ClassDB::bind_method(D_METHOD("self_test"), &NativeHash::self_test);
} 
