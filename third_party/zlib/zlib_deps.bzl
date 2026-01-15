"""zlib dependency setup"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def _zlib_deps_impl(_ctx):
    maybe(
        http_archive,
        name = "zlib",
        urls = ["https://github.com/madler/zlib/archive/refs/tags/v1.3.1.tar.gz"],
        sha256 = "17e88863f3600672ab49182f217281b6fc4d3c762bde361935e436a95214d05c",
        strip_prefix = "zlib-1.3.1",
        build_file = Label("//third_party/zlib:zlib_build.bzl"),
    )

zlib_deps = module_extension(
    implementation = _zlib_deps_impl,
)

