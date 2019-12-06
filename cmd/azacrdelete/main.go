package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"

	"github.com/urfave/cli"
)

// ShowManifests is az acr show-manifests command result.
type ShowManifests struct {
	Digest    string   `json:"digest"`
	Tags      []string `json:"tags"`
	Timestamp string   `json:"timestamp"`
}

func run(args []string) error {
	app := cli.NewApp()
	app.Name = "azacrdelete"
	app.Usage = "This command remove old image in Azure Container Registry."
	app.Version = "v1.0.0"
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:  "resource-group",
			Usage: "Name of resource group.",
		},
		cli.StringFlag{
			Name:     "name",
			Usage:    "The name of the container registry.",
			Required: true,
		},
		cli.StringFlag{
			Name:     "repository",
			Usage:    "The name of the repository.",
			Required: true,
		},
		cli.StringFlag{
			Name:  "subscription",
			Usage: "Name or ID of subscription.",
		},
		cli.IntFlag{
			Name:  "keep",
			Value: 20,
			Usage: "Keep image manifest, if 20 is set, the latest 20 manifests will remain.",
		},
	}
	app.Action = func(c *cli.Context) error {
		resourceGroup := c.String("resource-group")
		subscription := c.String("subscription")
		name := c.String("name")
		repository := c.String("repository")
		keep := c.Int("keep")

		showManifestsCommand := []string{"acr", "repository", "show-manifests", "--orderby", "time_desc"}
		if resourceGroup != "" {
			showManifestsCommand = append(showManifestsCommand, "--resource-group")
			showManifestsCommand = append(showManifestsCommand, resourceGroup)
		}
		if subscription != "" {
			showManifestsCommand = append(showManifestsCommand, "--subscription")
			showManifestsCommand = append(showManifestsCommand, subscription)
		}
		if name != "" {
			showManifestsCommand = append(showManifestsCommand, "--name")
			showManifestsCommand = append(showManifestsCommand, name)
		}
		if repository != "" {
			showManifestsCommand = append(showManifestsCommand, "--repository")
			showManifestsCommand = append(showManifestsCommand, repository)
		}
		// get repository image tag lists.
		out, err := exec.Command("az", showManifestsCommand...).Output()
		if err != nil {
			return err
		}
		var showManifests []ShowManifests
		bytes := []byte(out)
		if err := json.Unmarshal(bytes, &showManifests); err != nil {
			return err
		}

		repositoryDeleteCommand := []string{"acr", "repository", "delete", "--yes"}
		if name != "" {
			repositoryDeleteCommand = append(repositoryDeleteCommand, "--name")
			repositoryDeleteCommand = append(repositoryDeleteCommand, name)
		}
		if repository != "" {
			repositoryDeleteCommand = append(repositoryDeleteCommand, "--image")
		}

		var tmpCommand []string
		// repository delete image.
		for i, p := range showManifests {
			if keep <= i {
				fmt.Printf("%s : %s\n", p.Digest, p.Tags)
				tmpCommand = append(repositoryDeleteCommand, repository+"@"+p.Digest)
				out, err = exec.Command("az", tmpCommand...).Output()
				fmt.Println(out)
				if err != nil {
					return err
				}
			}
		}
		return nil
	}
	return app.Run(args)
}

func main() {
	run(os.Args)
}
