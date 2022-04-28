package test

import (
	// "fmt"
	"testing"
	// "time"

	// http_helper "github.com/gruntwork-io/terratest/modules/http-helper"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsHelloWorldExample(t *testing.T) {
	t.Parallel()

	/*Construct the terraform options with default retryable errors to handle the most common retryable errors in terraform testing. */
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		/* The path to where our Terraform code is located */
		TerraformDir: "../",
	})

	/* At the end of the test, run `terraform destroy` to clean up any resources that were created.*/
	defer terraform.Destroy(t, terraformOptions)

	/* Run `terraform init` and `terraform apply`. Fail the test if there are any errors. */
	terraform.InitAndApply(t, terraformOptions)
}

//go test -timeout 99999s
