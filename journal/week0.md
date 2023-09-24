# Terraform Beginner Bootcamp 2023 - week 0

- [Semantic Versioning :mage:](#semantic-versioning--mage-)
- [Using Git](#using-git)
  * [Creating Tags](#creating-tags)
  * [Deleting Tags](#deleting-tags)
  * [Switching branches or restoring working tree files](#switching-branches-or-restoring-working-tree-files)
    + [Move over the branch](#move-over-the-branch)
    + [Move to a specific tag](#move-to-a-specific-tag)
    + [Change branch](#change-branch)
  * [Saving your uncommitted work](#saving-your-uncommitted-work)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle - Before, Init, Command](#gitpod-lifecycle---before-init-command)
- [Working Env Vars](#working-env-vars)
  * [env command](#env-command)
  * [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
  * [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
    + [Terraform Lock Files](#terraform-lock-files)
    + [Terraform State Files](#terraform-state-files)
    + [Terraform Directory](#terraform-directory)
- [Issues with Terraform Cloud Login and Gitpod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)


The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Using Git

### Creating Tags

After PR or merge it's good practice to create a git tag using the following command:

`git tag 0.2.0`

And then push the tag to the git repository:

`git push --tags`

### Deleting Tags

If a tag is created and pushed by mistake, it can be deleted.

Delete the tag locally using the command `git tad -d 0.2.0`

Delete the tag from the remote repository using the command `git push --delete origin 0.2.0`

### Switching branches or restoring working tree files

Git checkout is what we use to move the HEAD over the commits in the branch, over tags or how to change branches.

#### Move over the branch

`git checkout 6c3f6da1dead19743c106ded03a33ef619912168`

#### Move to a specific tag

`git checkout 0.2.0`

#### Change branch

`git checkout main`

### Saving your uncommitted work

Use `git stash` when you want to record the current state of the working directory and the index, but want to go back to a clean working directory. The command saves your local modifications away and reverts the working directory to match the `HEAD` commit.

By default, stashes are marked as **WIP** on top of the branch and commit that you created the stash from. However, this limited amount of information isn't helpful when you have multiple stashes, as it becomes difficult to remember or individually check their contents. To add a description to the stash, you can use the command `git stash save <description>`.

You can view your stashes with the command `git stash list`. Stashes are saved in a last-in-first-out (LIFO) approach.

Then change your `HEAD` to the needed branch and use either the command `git stash pop` or `git stash apply` to apply the saved changes.

The `git stash pop` removes the changes from your stash and reapplies them to your working copy.

The `git stash apply` is useful if you want to apply the same stashed changes to multiple branches.

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the lastest install CLI instructions via Terraform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu.
Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How to Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line)

Example of checking OS Version:

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```


### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we noticed that the bash scipts steps were a considerable amount of code. Se we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](./gitpod.yml)) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install.
- This allow better portability for other projects that need to install Terraform CLI.

#### Shebang Considerations

A Shebang (pronounced sha-bang) tells the bash script what program will interpret the script, eg. `#!/bin/bash`

ChatGPT recommended thir format for bash: `#!/usr/bin/env bash`

- for portability for different OS distributions
- will search for user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorhand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://pt.wikipedia.org/wiki/Chmod

## Gitpod Lifecycle - Before, Init, Command

We need to be careful when using the `Init` because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

## Working Env Vars

### env command

We can list out all Environment Variables (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `end | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can ser using `export HELLO='world'`

In the terminal we can unser using `enset HELLO`

We can set env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export, eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Vars

We can print an env var using echo. eg. `echo $HELLO`

### Scoping of Env Vars

When you open a new bash terminals in VSCode it will not be aware of env varts that you have set in another window.

If you want to Env Vars to persist across all future bash terminals that are open, you need to set env vars in your bash profile. eg. `.bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpot by sroting them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.

## AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like this:

```json
{
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials from IAM User in order to the user AWS CLI, by running `gp env` in the terminal, eg.

```sh
gp env AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
gp env AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
gp env AWS_DEFAULT_REGION='eu-central-1'
```

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow to create resources in terraform.
- **Modules** are a way to make large amount of terraform code modular, portable and shareable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/)

[AWS Terraform Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`

#### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`

This will destroy resources.

You can also use the auto approve flag to skip the approve prompt, eg. `terraform destroy --auto-approve`

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VCS), eg. Github

#### Terraform State Files

`terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be committed** to your VCS.

This file can contains sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terrafor login` it will launch bash a wiswig view to generate a token. However it does not work as expected int Gitpod VSCode in the browser.

The workaround is manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

Then create open the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json 
open /home/gitpod/.terraform.d/credentials.tfrc.json 
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

We have automated this workaround with the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)
