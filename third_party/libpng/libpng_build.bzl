"""Build file for libpng using rules_foreign_cc with CMake"""

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all_srcs",
    srcs = glob(
        ["**"],
        exclude = ["*.bazel"],
    ),
)

cmake(
    name = "libpng",
    lib_source = ":all_srcs",
    build_args = ["-j8"],
    cache_entries = {
        "BUILD_SHARED_LIBS": "OFF",
        "PNG_SHARED": "OFF",
        "PNG_STATIC": "ON",
        "PNG_TESTS": "OFF",
        "PNG_TOOLS": "OFF",
        # macOS specific
        "CMAKE_OSX_DEPLOYMENT_TARGET": "10.15",
    },
    out_include_dir = "include",
    out_static_libs = ["libpng.a"],
    deps = [
        "@zlib//:zlib",
    ],
    visibility = ["//visibility:public"],
)

