// package main: Declares the package name
// The main package is a special in Go, it's 
// where the execution of the program starts
package main

// import "fmt": Imports the fmt package.
// It shorts for format, which contains 
// functions for formated I/O.
import (
	"log"
	"fmt"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

// func main(): Defines the main function, the
// entrypoint of the application, when you run
// the program, it starts executing from this function
func main()  {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider
	})
	// Format.PrintLine
	// prints to standard output
	// fmt.Println("Hello, world!")
}

// https://developer.hashicorp.com/terraform/tutorials/providers/provider-setup
// in Golang
func Provider() *schema.Provider{
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			x
		},
    DataSourcesMap: map[string]*schema.Resource{
			x
		},
		Schema: map[string]*schema.Resource{
			"endpoint": {
				Type: schema.TypeString,
				Required: true,
				Description: "The endpoint for the external service"
			}.
			"token": {
				Type: schema.TypeString,
				Sensitive: true, // make the token as sensitive to hide it in the logs
				Required: true,
				Description: "The bearer token for authorization"
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,
				Description: "The UUID for configuration",
				ValidateFunc: validateUUID
			}
		}
	}
	p.ConfigureContextFunc = providerConfigure(p)
	return p
}

func validateUUID(v interface{}, k string) (ws []string, errors []error){
	log.Print('validateUUID:start')
	value := v.(string)
	if _, err = uui.Parse(value); err != nil {
		errors = append(error, fmt.Errorf("invalid UUID format"))
	}
	log.Print('validateUUID:end')
	return
}