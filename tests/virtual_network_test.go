package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../",
		Parallelism:  2,
		//NoColor:      true,
	})

	defer terraform.Destroy(t, terraformOptions)
	out := terraform.InitAndApply(t, terraformOptions)

	// Check that NoColor correctly doesn't output the colour escape codes which look like [0m,[1m or [32m
	require.NotRegexp(t, `\[\d*m`, out, "Output should not contain color escape codes")
}
