# Terraform Beginner Bootcamp 2023 - week 1

![image](https://github.com/f616/terraform-beginner-bootcamp-2023/assets/3826426/65b8a182-1f61-4862-bb9a-1610ff79ec82)

- [Root Module Structure](#root-module-structure)
- [Terraform and Input Variables](#terraform-and-input-variables)
  * [Terraform Cloud Variables](#terraform-cloud-variables)
  * [Loading Terraform Input Variables](#loading-terraform-input-variables)
  * [var flag](#var-flag)
  * [var-file flag](#var-file-flag)
  * [terraform.tfvars](#terraformtfvars)
  * [auto.tfvars](#autotfvars)
  * [order of terraform variables](#order-of-terraform-variables)
- [Dealing with Configuration Drift](#dealing-with-configuration-drift)
  * [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
  * [Terraform Import](#terraform-import)
  * [Fix using Terraform Refresh](#fix-using-terraform-refresh)
- [Terraform Modules](#terraform-modules)
  * [Terraform Module Structure](#terraform-module-structure)
  * [Passing Input Variables](#passing-input-variables)
  * [Modules Sources](#modules-sources)
- [Considerations when using ChatGPT to write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
- [Working with Files in Terraform](#working-with-files-in-terraform)
  * [Fileexist Function](#fileexist-function)
  * [Filemd5](#filemd5)
  * [Path Variable](#path-variable)
  * [Terrafor Locals](#terrafor-locals)
  * [Terraform Data Sources](#terraform-data-sources)
- [Working with JSON](#working-with-json)
  * [Changing the Lifecycle of Resources](#changing-the-lifecycle-of-resources)
- [Terraform Data](#terraform-data)
- [Provisioners](#provisioners)
  * [Local-exec](#local-exec)
  * [Remote-exec](#remote-exec)
- [For Each Expressions](#for-each-expressions)

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

```tf
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

```tf
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


```tf
module "terrahouse_aws"{
    source = "./modules/terrahouse_aws"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the lastest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform

### Fileexist Function

This is a built-in terraform funcion to check the existence of a file.

```tf
condition = fileexists(var.index_html_filepath)
```

[fileexists function](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5

[filemd5 function](https://developer.hashicorp.com/terraform/language/functions/filemd5)


### Path Variable

In Terraform there is a special variable called `path` that allows us to reference local paths:

- `path.module` = get the path for the current module
- `path.root` = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}
```

### Terrafor Locals

Locals allows us to define local variables.
It can be very useful when we need to transform data into another format and have it referenced as a variable.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allow us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the `jsonencode` to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}

```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in `replace_triggered_by`. You can use `terraform_data`'s behavior of planning an action each time `input` changes to *indirectly* use a plain value to trigger replacement.

[terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners

Provisioners allows you to execute commands on compute instances eg. an AWS CLI command.

They are not recommended for use by Hasicorp because Configuration Management tools such as Ansible are a better fit, but functionality exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute command on the machine running the terraform commands, eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

[local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```json
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

[remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

## For Each Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each expressions](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
