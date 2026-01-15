"""Build file for Tesseract OCR using rules_foreign_cc with CMake"""

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all_srcs",
    srcs = glob(
        ["**"],
        exclude = ["*.bazel"],
    ),
)

cmake(
    name = "tesseract",
    lib_source = ":all_srcs",
    build_args = ["-j8"],
    cache_entries = {
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_TRAINING_TOOLS": "OFF",
        "DISABLE_CURL": "ON",
        "DISABLE_ARCHIVE": "ON",
        "GRAPHICS_DISABLED": "ON",
        "DISABLED_LEGACY_ENGINE": "OFF",
        # Use C++17 for std::filesystem support
        "CMAKE_CXX_STANDARD": "17",
        # Point to leptonica from deps - cmake will find the LeptonicaConfig.cmake
        "Leptonica_DIR": "$$EXT_BUILD_DEPS$$/leptonica/lib/cmake/leptonica",
        "LEPTONICA_INCLUDE_DIRS": "$$EXT_BUILD_DEPS$$/leptonica/include",
        "Leptonica_INCLUDE_DIRS": "$$EXT_BUILD_DEPS$$/leptonica/include",
        # macOS specific: set minimum version for C++17 std::filesystem
        "CMAKE_OSX_DEPLOYMENT_TARGET": "10.15",
    },
    out_include_dir = "include",
    out_static_libs = ["libtesseract.a"],
    deps = [
        "@leptonica//:leptonica",
    ],
    visibility = ["//visibility:public"],
)
