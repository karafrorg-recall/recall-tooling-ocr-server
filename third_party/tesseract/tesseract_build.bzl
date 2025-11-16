"""Build file for Tesseract OCR using rules_foreign_cc"""

load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

filegroup(
    name = "all_srcs",
    srcs = glob(
        ["**"],
        exclude = ["*.bazel"],
    ),
)

configure_make(
    name = "tesseract",
    lib_source = ":all_srcs",
    configure_in_place = True,
    args = ["-j8"],
    targets = ["install-libLTLIBRARIES", "install-data"],
    autogen = True,
    autogen_command = "autogen.sh",
    configure_options = [
        "--enable-static",
        "--disable-shared",
        "--disable-openmp",
        "--disable-graphics",
        "--without-curl",
        "--without-archive",
        "--disable-programs",
    ],
    env = {
        "PKG_CONFIG_PATH": "$$EXT_BUILD_DEPS$$/leptonica/lib/pkgconfig",
        "LIBLEPT_HEADERSDIR": "$$EXT_BUILD_DEPS$$/leptonica/include",
        "LEPTONICA_CFLAGS": "-I$$EXT_BUILD_DEPS$$/leptonica/include",
        "LEPTONICA_LIBS": "-L$$EXT_BUILD_DEPS$$/leptonica/lib -llept",
        "CPPFLAGS": "-I$$EXT_BUILD_DEPS$$/leptonica/include",
        "LDFLAGS": "-L$$EXT_BUILD_DEPS$$/leptonica/lib",
        "AR": "ar",
        "RANLIB": "ranlib",
    },
    out_static_libs = ["libtesseract.a"],
    deps = [
        "@leptonica//:leptonica",
    ],
    visibility = ["//visibility:public"],
)
