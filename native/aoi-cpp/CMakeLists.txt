# =====================================================================
# aoi-cpp — HoyoAO-3rd NATIVE CORE (ENGINE-AGNOSTIC)
# Owner: C++ Core Directorate + Principal Engineer
# Law:   C++ CORE AUTHORITY > GDSCRIPT CONVENIENCE
#        FIREWALL: chỉ src/gdext_boundary/ được include godot-cpp
# =====================================================================
cmake_minimum_required(VERSION 3.25)
project(aoi_cpp VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

option(AOI_BUILD_GDEXT "Build Godot GDExtension adapter" ON)
option(AOI_BUILD_TESTS "Build unit/golden/fuzz tests"    ON)
option(AOI_WERROR      "Treat warnings as errors"        ON)

# ---------- ABI / API VERSIONING (audit trail, boundary versioned) ----------
set(AOI_ABI_VERSION 1)
set(AOI_API_VERSION 1)
add_compile_definitions(
    AOI_ABI_VERSION=${AOI_ABI_VERSION}
    AOI_API_VERSION=${AOI_API_VERSION}
)

if(AOI_WERROR AND NOT MSVC)
    add_compile_options(-Wall -Wextra -Werror)
endif()

# ---------- ENGINE-AGNOSTIC CORE (STATIC) ----------
file(GLOB_RECURSE AOI_CORE_SOURCES CONFIGURE_DEPENDS
    src/core/*.cpp
    src/crypto/*.cpp
    src/save_vault/*.cpp
    src/econ/*.cpp
    src/owner_console/*.cpp
    src/quality_governor/*.cpp
    src/combat_sim/*.cpp
    src/content_domain/*.cpp
)
add_library(aoi_core STATIC ${AOI_CORE_SOURCES})
target_include_directories(aoi_core
    PUBLIC  ${CMAKE_CURRENT_SOURCE_DIR}/include
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src
)
# FIREWALL LAW: aoi_core không link, không thấy godot-cpp dưới mọi hình thức.
target_compile_definitions(aoi_core PUBLIC AOI_ENGINE_NONE=1)

# ---------- ANDROID (MOBILE-FIRST) ----------
if(ANDROID)
    include(cmake/AoiAndroid.cmake)
    aoi_apply_android_flags(aoi_core)
endif()

# ---------- GODOT ADAPTER (SHARED) — nơi duy nhất chạm godot-cpp ----------
if(AOI_BUILD_GDEXT)
    set(GODOT_CPP_DIR ${CMAKE_CURRENT_SOURCE_DIR}/third_party/godot-cpp)
    if(NOT EXISTS ${GODOT_CPP_DIR}/CMakeLists.txt)
        message(FATAL_ERROR
            "godot-cpp submodule missing. Run: git submodule update --init --recursive")
    endif()
    add_subdirectory(${GODOT_CPP_DIR} godot-cpp EXCLUDE_FROM_ALL)

    file(GLOB_RECURSE AOI_GDEXT_SOURCES CONFIGURE_DEPENDS src/gdext_boundary/*.cpp)
    add_library(aoi_gdext SHARED ${AOI_GDEXT_SOURCES})
    target_link_libraries(aoi_gdext PRIVATE godot-cpp aoi_core)
    target_include_directories(aoi_gdext PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
        ${CMAKE_CURRENT_SOURCE_DIR}/src
    )

    if(ANDROID)
        aoi_apply_android_flags(aoi_gdext)
        set_target_properties(aoi_gdext PROPERTIES
            OUTPUT_NAME "aoi_cpp.android.${ANDROID_ABI}")
    elseif(WIN32)
        set_target_properties(aoi_gdext PROPERTIES
            OUTPUT_NAME "aoi_cpp.windows.x86_64")
    else()
        set_target_properties(aoi_gdext PROPERTIES
            OUTPUT_NAME "aoi_cpp.linux.x86_64")
    endif()
endif()

# ---------- TESTS (host only — CI, KHÔNG phải chuẩn benchmark) ----------
if(AOI_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif() 
