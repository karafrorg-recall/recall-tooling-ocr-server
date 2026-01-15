"""Tessdata (trained data files) dependency setup"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def _tessdata_deps_impl(_ctx):
    # Download eng.traineddata for English language support
    maybe(
        http_file,
        name = "tessdata_eng",
        urls = ["https://github.com/tesseract-ocr/tessdata_fast/raw/main/eng.traineddata"],
        sha256 = "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2",
        downloaded_file_path = "eng.traineddata",
    )

tessdata_deps = module_extension(
    implementation = _tessdata_deps_impl,
)

