"""Repository rule to wrap gosseract with proper tesseract/leptonica linking"""

def _gosseract_wrapper_impl(ctx):
    # Download the gosseract source
    ctx.download_and_extract(
        url = "https://github.com/otiai10/gosseract/archive/refs/tags/v2.4.1.tar.gz",
        sha256 = "a6d0cbc6a28342ce4ed2ce97e4a81679a91411b55e59b52d9bb5dd1b8017e870",
        stripPrefix = "gosseract-2.4.1",
    )

    # Don't patch tessbridge.cpp - the cmake build exports headers with leptonica/ prefix
    # so #include <leptonica/allheaders.h> is correct

    # Completely rewrite preprocessflags_x.go to remove all CGO directives
    # since we're linking via cdeps instead
    ctx.file("preprocessflags_x.go", """//go:build !freebsd
// +build !freebsd

package gosseract
""")

    # Completely rewrite preprocessflags_freebsd.go
    ctx.file("preprocessflags_freebsd.go", """//go:build freebsd
// +build freebsd

package gosseract
""")

    # Create BUILD.bazel using direct external repo references
    # Use @leptonica and @tesseract which are the actual repos defined via module extensions
    build_file_content = """load("@rules_go//go:def.bzl", "go_library")

go_library(
    name = "gosseract",
    srcs = [
        "client.go",
        "constant.go",
        "hocr.go",
        "preprocessflags_freebsd.go",
        "preprocessflags_x.go",
        "tessbridge.cpp",
        "tessbridge.h",
    ],
    cdeps = [
        "@leptonica//:leptonica",
        "@tesseract//:tesseract",
    ],
    cgo = True,
    clinkopts = select({
        "@platforms//os:macos": ["-framework Accelerate"],
        "//conditions:default": [],
    }),
    copts = ["-I."],
    importpath = "github.com/otiai10/gosseract/v2",
    visibility = ["//visibility:public"],
)
"""

    ctx.file("BUILD.bazel", build_file_content)

gosseract_wrapper = repository_rule(
    implementation = _gosseract_wrapper_impl,
    attrs = {},
)

def _gosseract_repos_ext_impl(_):
    gosseract_wrapper(name = "gosseract_local")

gosseract_repos_ext = module_extension(
    implementation = _gosseract_repos_ext_impl,
)

