"""Leptonica dependency setup"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def _leptonica_deps_impl(ctx):
    maybe(
        http_archive,
        name = "leptonica",
        urls = ["https://github.com/DanBloomberg/leptonica/archive/refs/tags/1.84.1.tar.gz"],
        sha256 = "ecd7a868403b3963c4e33623595d77f2c87667e2cfdd9b370f87729192061bef",
        strip_prefix = "leptonica-1.84.1",
        build_file = Label("//third_party/leptonica:leptonica_build.bzl"),
    )

leptonica_deps = module_extension(
    implementation = _leptonica_deps_impl,
)

