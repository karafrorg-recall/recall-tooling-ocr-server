"""Build file for zlib using rules_foreign_cc with CMake"""

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all_srcs",
    srcs = glob(
        ["**"],
        exclude = ["*.bazel"],
    ),
)

cmake(
    name = "zlib",
    lib_source = ":all_srcs",
    build_args = ["-j8"],
    cache_entries = {
        "BUILD_SHARED_LIBS": "OFF",
        # macOS specific
        "CMAKE_OSX_DEPLOYMENT_TARGET": "10.15",
    },
    out_include_dir = "include",
    out_static_libs = select({
        "@platforms//os:windows": ["zlibstatic.lib"],
        "//conditions:default": ["libz.a"],
    }),
    visibility = ["//visibility:public"],
)

