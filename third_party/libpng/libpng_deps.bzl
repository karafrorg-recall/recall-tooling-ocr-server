"""libpng dependency setup"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def _libpng_deps_impl(_ctx):
    maybe(
        http_archive,
        name = "libpng",
        urls = ["https://github.com/pnggroup/libpng/archive/refs/tags/v1.6.43.tar.gz"],
        sha256 = "fecc95b46cf05e8e3fc8a414750e0ba5aad00d89e9fdf175e94ff041caf1a03a",
        strip_prefix = "libpng-1.6.43",
        build_file = Label("//third_party/libpng:libpng_build.bzl"),
    )

libpng_deps = module_extension(
    implementation = _libpng_deps_impl,
)

