"""BUILD file for tessdata"""

filegroup(
    name = "eng",
    srcs = ["eng.traineddata"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "all_traineddata",
    srcs = glob(["*.traineddata"]),
    visibility = ["//visibility:public"],
)

