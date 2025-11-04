package main

import (
	gw "github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	pb "github.com/karafrorg-recall/recall-tooling-ocr-server/api/proto/recall_tooling_ocr_server/v1"
)

func main() {
	_ = pb.ProcessImageRequest{}
	_, _ = gw.String("")
	pb.RegisterRecallToolingOcrServerServer(nil, nil)
}
