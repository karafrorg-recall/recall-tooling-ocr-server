"""Build file for Leptonica library using rules_foreign_cc with CMake"""

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all_srcs",
    srcs = glob(
        ["**"],
        exclude = ["*.bazel"],
    ),
)

cmake(
    name = "leptonica",
    lib_source = ":all_srcs",
    build_args = ["-j8"],
    cache_entries = {
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_PROG": "OFF",
        # Enable PNG and ZLIB for image format support
        "ENABLE_GIF": "OFF",
        "ENABLE_JPEG": "OFF",
        "ENABLE_PNG": "ON",
        "ENABLE_TIFF": "OFF",
        "ENABLE_ZLIB": "ON",
        "ENABLE_WEBP": "OFF",
        "ENABLE_OPENJPEG": "OFF",
        # macOS specific
        "CMAKE_OSX_DEPLOYMENT_TARGET": "10.15",
        # Tell CMake where to find zlib and libpng from our deps
        "ZLIB_ROOT": "$$EXT_BUILD_DEPS$$/zlib",
        "PNG_ROOT": "$$EXT_BUILD_DEPS$$/libpng",
        "CMAKE_PREFIX_PATH": "$$EXT_BUILD_DEPS$$/zlib;$$EXT_BUILD_DEPS$$/libpng",
    },
    out_include_dir = "include",
    out_static_libs = ["libleptonica.a"],
    deps = [
        "@libpng//:libpng",
        "@zlib//:zlib",
    ],
    visibility = ["//visibility:public"],
)
