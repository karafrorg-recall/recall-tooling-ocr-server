package configs

import "embed"

//go:embed *.toml
var EmbededConfigs embed.FS
