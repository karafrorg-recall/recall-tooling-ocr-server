"""Tesseract dependency setup"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")



def _tesseract_deps_impl(_ctx):
    maybe(
        http_archive,
        name = "tesseract",
        urls = ["https://github.com/tesseract-ocr/tesseract/archive/refs/tags/5.3.4.tar.gz"],
        sha256 = "141afc12b34a14bb691a939b4b122db0d51bd38feda7f41696822bacea7710c7",
        strip_prefix = "tesseract-5.3.4",
        build_file = Label("//third_party/tesseract:tesseract_build.bzl"),
    )

tesseract_deps = module_extension(
    implementation = _tesseract_deps_impl,
)

