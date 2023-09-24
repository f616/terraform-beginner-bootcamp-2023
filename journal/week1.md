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

This flags allows you to specify a .tfvars file to be loaded, eg. `terraform apply -var-file="testing.tfvars"`.

The file format uses the basic syntax as Terraform language files, but consists only of variable name assignments:

```TOML
image_id = "ami-abc123"
availability_zone_names = [
  "us-east-1a",
  "us-west-1c",
]
```

JSON format is also valid, however the files should be named like `.tfvars.json`, eg. `testing.tfvars.json`:

```json
{
  "image_id": "ami-abc123",
  "availability_zone_names": ["us-west-1a", "us-west-1c"]
}
```

### terraform.tfvars

This is the default file to load in terraform variable in bulk.
`terraform.tfvars.json` is also a valid filename as long as it's *json* formated.

### auto.tfvars

Besides `terraform.tfvars` file, Terraform will also automatically loads files with names ending in `.auto.tfvars`.

Terraform is also able to read `.auto.tfvars.json` files.


### order of terraform variables

All mechanisms for setting variables can be used together in any combination. If the same variable is assigned multiple values, Terraform uses the last value it finds, overriding any previous values. Note that the same variable cannot be assigned multiple values within a single source.

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The `terraform.tfvars` file, if present.
- The `terraform.tfvars.json` file, if present.
- Any `*.auto.tfvars` or `*.auto.tfvars.json` files, processed in lexical order of their filenames.
- Any `-var` and `-var-file` options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

## Dealing with Configuration Drift

If you loose your statefile, you must likely have to tear down all your cloud infrastructure manually.

You can use `terraform import`, but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terrafor Import](https://developer.hashicorp.com/terraform/cli/import)

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Terraform Import

If someone goes and deletes or modifies cloud resource manually through ClickOps.

If we run `terraform plan` is with attempt to put our infrastructure back into the expected state fixing Configuration Drift.

### Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing modules but can name it whatever you like.

```sh
$ tree complete-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   ├── nestedB/
│   ├── .../
├── examples/
│   ├── exampleA/
│   │   ├── main.tf
│   ├── exampleB/
│   ├── .../
```

[Modules Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables into it's own variables.tf.

```TOML
module "terrahouse_aws"{
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places, eg:

- locally
- Github
- Terraform Registry


```TOML
module "terrahouse_aws"{
    source = "./modules/terrahouse_aws"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)