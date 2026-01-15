package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/bazelbuild/rules_go/go/runfiles"
	"github.com/otiai10/gosseract/v2"
)

func init() {
	// Skip if TESSDATA_PREFIX is already set
	if os.Getenv("TESSDATA_PREFIX") != "" {
		return
	}

	// Resolve tessdata path from Bazel env variable (set by bazel run)
	if rloc := os.Getenv("TESSDATA_RLOCATION"); rloc != "" {
		if r, err := runfiles.New(); err == nil {
			if path, err := r.Rlocation(rloc); err == nil {
				os.Setenv("TESSDATA_PREFIX", filepath.Dir(path))
				return
			}
		}
	}

	// Fallback: look for tessdata relative to executable (standalone execution)
	if exe, err := os.Executable(); err == nil {
		// Check runfiles directory next to executable
		runfilesDir := exe + ".runfiles"
		candidates := []string{
			filepath.Join(runfilesDir, "_main", "external", "+tessdata_deps+tessdata_eng", "file"),
			filepath.Join(runfilesDir, "+tessdata_deps+tessdata_eng", "file"),
		}
		for _, dir := range candidates {
			if _, err := os.Stat(filepath.Join(dir, "eng.traineddata")); err == nil {
				os.Setenv("TESSDATA_PREFIX", dir)
				return
			}
		}
	}
}

func main() {
	client := gosseract.NewClient()
	defer client.Close()
	if err := client.SetImage("/Users/matustoth/GolandProjects/recall-tooling-ocr-server/test.png"); err != nil {
		fmt.Println("Error setting image:", err)
		return
	}
	text, err := client.Text()
	if err != nil {
		fmt.Println("Error during OCR:", err)
		return
	}
	fmt.Println("Extracted Text:", text)
	fmt.Println("Recall Tooling OCR Server")
}
