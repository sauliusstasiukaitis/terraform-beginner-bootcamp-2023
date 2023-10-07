package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})

	fmt.Println("Hello, world")
}

type Config struct {
	Endpoint string
	Token    string
	UserUuid string
}

// & references a pointer.
// * dereferences a pointer.
func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			"terratowns_home": Resource(),
		},
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
				Type:         schema.TypeString,
				Required:     true,
				ValidateFunc: validateUUID,
			},
		},
	}
	p.ConfigureContextFunc = providerConfigure(p)
	return p
}

func providerConfigure(p *schema.Provider) schema.ConfigureContextFunc {
	return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
		log.Print("providerConfigure:start")
		config := Config{
			Endpoint: d.Get("endpoint").(string),
			Token:    d.Get("token").(string),
			UserUuid: d.Get("user_uuid").(string),
		}
		log.Print("providerConfigure:end")
		return &config, nil
	}
}

func validateUUID(v interface{}, k string) (ws []string, errors []error) {
	log.Print("validateUUID:start")
	value := v.(string)
	if _, err := uuid.Parse(value); err != nil {
		errors = append(errors, fmt.Errorf("invalid UUID format \n"))
	}

	log.Print("validateUUID:end")

	return
}

func Resource() *schema.Resource {
	log.Print("Resource:start")
	resource := &schema.Resource{
		CreateContext: resourceHouseCreate,
		ReadContext:   resourceHouseRead,
		UpdateContext: resourceHouseUpdate,
		DeleteContext: resourceHouseDelete,
		Schema: map[string]*schema.Schema{
			"name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "Name of home",
			},
			"description": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "Name of home",
			},
			"domain_name": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "Domain name of home e.g. ",
			},
			"town": {
				Type:        schema.TypeString,
				Required:    true,
				Description: "The town to which the home belongs to",
			},
			"content_version": {
				Type:     schema.TypeInt,
				Required: true,
			},
		},
	}
	log.Print("Resource:end")
	return resource
}

func resourceHouseCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseCreate:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	payload := map[string]interface{}{
		"name":            d.Get("name").(string),
		"description":     d.Get("description").(string),
		"domain_name":     d.Get("domain_name").(string),
		"town":            d.Get("town").(string),
		"content_version": d.Get("content_version").(int),
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}

	reqBody := bytes.NewBuffer(payloadBytes)

	url := config.Endpoint + "/u/" + config.UserUuid + "/homes"
	log.Printf("URL: %s", url)

	req, err := http.NewRequest("POST", url, reqBody)
	if err != nil {
		log.Printf("Create error: %s", err)

		return diag.FromErr(err)
	}

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Printf("Create request error: %s", err)

		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	log.Printf("Response Status Code: %d", resp.StatusCode)

	var responseData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		log.Printf("Create decode error: %s", err)

		return diag.FromErr(err)
	}

	if resp.StatusCode != http.StatusOK {
		log.Printf("Create status error: %s", err)

		return diag.FromErr(fmt.Errorf(
			"Failed to CREATE home resource, status code %d, status %s, body %s \n",
			resp.StatusCode,
			resp.Status,
			responseData,
		))
	}

	homeUUID := responseData["uuid"].(string)
	d.SetId(homeUUID)

	log.Print("resourceHouseCreate:end")
	return diags
}

func resourceHouseRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseRead:start")
	var diags diag.Diagnostics

	homeUUID := d.Id()

	config := m.(*Config)
	url := config.Endpoint + "/u/" + config.UserUuid + "/homes/" + homeUUID
	log.Printf("URL: %s", url)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return diag.FromErr(err)
	}

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	log.Printf("Response Status Code: %d", resp.StatusCode)

	var responseData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return diag.FromErr(err)
	}

	if resp.StatusCode == http.StatusOK {
		d.Set("name", responseData["name"].(string))
		d.Set("description", responseData["description"].(string))
		d.Set("domain_name", responseData["domain_name"].(string))
		d.Set("content_version", responseData["content_version"].(float64))
	} else if resp.StatusCode == http.StatusNotFound {
		d.SetId("")
	} else {
		return diag.FromErr(fmt.Errorf(
			"Failed to READ home resource, status code %d, status %s, body %s \n",
			resp.StatusCode,
			resp.Status,
			responseData,
		))
	}

	log.Print("resourceHouseRead:end")
	return diags
}

func resourceHouseUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseUpdate:start")
	var diags diag.Diagnostics

	homeUUID := d.Id()

	config := m.(*Config)

	payload := map[string]interface{}{
		"name":            d.Get("name").(string),
		"description":     d.Get("description").(string),
		"content_version": d.Get("content_version").(int),
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}

	reqBody := bytes.NewBuffer(payloadBytes)

	url := config.Endpoint + "/u/" + config.UserUuid + "/homes/" + homeUUID
	log.Printf("URL: %s", url)

	req, err := http.NewRequest("PUT", url, reqBody)
	if err != nil {
		return diag.FromErr(err)
	}

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	log.Printf("Response Status Code: %d", resp.StatusCode)

	var responseData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return diag.FromErr(err)
	}

	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf(
			"Failed to UPDATE home resource, status code %d, status %s, body %s \n",
			resp.StatusCode,
			resp.Status,
			responseData,
		))
	}

	d.Set("name", payload["name"])
	d.Set("description", payload["description"])
	d.Set("content_version", payload["content_version"])

	log.Print("resourceHouseUpdate:end")
	return diags
}

func resourceHouseDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHouseDelete:start")
	var diags diag.Diagnostics

	homeUUID := d.Id()

	config := m.(*Config)
	url := config.Endpoint + "/u/" + config.UserUuid + "/homes/" + homeUUID
	log.Printf("URL: %s", url)

	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		return diag.FromErr(err)
	}

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	log.Printf("Response Status Code: %d", resp.StatusCode)

	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf(
			"Failed to DELETE home resource, status code %d, status %s \n",
			resp.StatusCode,
			resp.Status,
		))
	}

	d.SetId("")
	log.Print("resourceHouseDelete:end")
	return diags
}
