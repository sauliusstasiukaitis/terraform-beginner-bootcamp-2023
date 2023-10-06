package main

import (
	"fmt"

	// "github.com/google/uuid"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})

	fmt.Println("Hello, world")
}

// & references a pointer.
// * dereferences a pointer.
func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap:   map[string]*schema.Resource{},
		DataSourcesMap: map[string]*schema.Resource{},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type:     schema.TypeString,
				Required: true,
			},
			"token": {
				Type:        schema.TypeString,
				Sensitive:   true,
				Required:    true,
				Description: "Bearer token for authorization",
			},
			"user_uuid": {
				Type:     schema.TypeString,
				Required: true,
				// ValidateFunc: validateUUID,
			},
		},
	}
	// p.ConfigureContextFunc = providerConfigure()
	return p
}

// func providerConfigure() {}

// func validateUUID(uuid string) bool {
// 	log.Print("validateUUID:start")

// 	_, err := uuid.Parse(uuid)

// 	log.Print("validateUUID:end")

// 	return err == nil
// }
