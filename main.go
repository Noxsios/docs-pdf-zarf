package main

import (
	"os"
	"path/filepath"
	"sort"
	"strings"

	"github.com/defenseunicorns/zarf/src/cmd"
	"github.com/defenseunicorns/zarf/src/cmd/tools"
	"github.com/defenseunicorns/zarf/src/pkg/message"
	"github.com/defenseunicorns/zarf/src/pkg/utils"
	"github.com/spf13/cobra"
	"github.com/spf13/cobra/doc"
)

func addHiddenDummyFlag(cmd *cobra.Command, flagDummy string) {
	if cmd.PersistentFlags().Lookup(flagDummy) == nil {
		var dummyStr string
		cmd.PersistentFlags().StringVar(&dummyStr, flagDummy, "", "")
		cmd.PersistentFlags().MarkHidden(flagDummy)
	}
}


func main() {

	dst := filepath.Join("zarf-docs")

	if err := os.RemoveAll(dst); err != nil {
		message.Fatal(err, "Failed to remove directory")
	}

	if err := utils.CreateDirectory(dst, 0755); err != nil {
		message.Fatal(err, "Failed to create directory")
	}

	rootCmd := cmd.RootCmd()
	rootCmd.DisableAutoGenTag = true

	for _, cmd := range rootCmd.Commands() {
		if cmd.Use == "tools" {
			for _, toolCmd := range cmd.Commands() {
				// If the command is a vendored command, add a dummy flag to hide root flags from the docs
				if tools.CheckVendorOnlyFromPath(toolCmd) {
					addHiddenDummyFlag(toolCmd, "log-level")
					addHiddenDummyFlag(toolCmd, "architecture")
					addHiddenDummyFlag(toolCmd, "no-log-file")
					addHiddenDummyFlag(toolCmd, "no-progress")
					addHiddenDummyFlag(toolCmd, "zarf-cache")
					addHiddenDummyFlag(toolCmd, "tmpdir")
					addHiddenDummyFlag(toolCmd, "insecure")
				}
			}
		}
	}

	if err := doc.GenYamlTree(rootCmd, dst); err != nil {
		message.Fatal(err, "Failed to generate docs")
	} else {
		message.Successf("Docs generated in %s", dst)
	}

	files, err := filepath.Glob(filepath.Join(dst, "*.yaml"))
	if err != nil {
		message.Fatal(err, "Failed to glob docs")
	}

	sort.Strings(files)
	text := strings.Join(files, "\n")
	if err := utils.WriteFile(filepath.Join(dst, "ls.txt"), []byte(text)); err != nil {
		message.Fatal(err, "Failed to write ls.txt")
	}
}
