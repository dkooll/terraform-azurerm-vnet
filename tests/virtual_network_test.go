package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func ValidateDeployment(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../",
		Parallelism:  2,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
