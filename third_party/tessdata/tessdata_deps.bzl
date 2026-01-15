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
    # Download slk.traineddata for Slovak language support
    maybe(
        http_file,
        name = "tessdata_slk",
        urls = ["https://github.com/tesseract-ocr/tessdata_fast/raw/main/slk.traineddata"],
        sha256 = "fbcc400a9c74c6a13d922fcb1211b655d1b165387b675ed75cd2dbd756b974a5",
        downloaded_file_path = "slk.traineddata",
    )


tessdata_deps = module_extension(
    implementation = _tessdata_deps_impl,
)

