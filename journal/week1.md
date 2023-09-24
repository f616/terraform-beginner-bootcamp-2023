# Terraform Beginner Bootcamp 2023 - week 1

## Root Module Structure

Our root module structure is as follows:

```sh
PROJECT_ROOT
│
├── main.tf                 # everything else
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required by root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two kinds of variables:
- Environment Variables - those you would set in your bash terminal eg. AWS_ACCESS_KEY_ID
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Variables to be sensitive so they are not shown visible in the UI

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uuid="my-user-uuid"`

### var-file flag

- **TODO:** document this flag

### terraform.tfvars

This is tge default file to load in terraform variable in blunk

### auto.tfvars

- **TODO:** document this functionality for terraform cloud

### order of terraform variables

- **TODO:** document which terraform variables take precedence
