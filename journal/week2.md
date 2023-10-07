# Terraform Beginner Bootcamp 2023 - week 2

![image](https://github.com/f616/terraform-beginner-bootcamp-2023/assets/3826426/abf401ed-79ab-45e2-aab9-394220704f87)

## Working with Ruby

### Bundler is a package manager

Bundler is a package manager for ruby. It is the primary way to install ruby packages (known as gems) for ruby.

#### Install Gems

You need to create a Gemfile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

The you need to run the `bundle install` command.

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules).

A Gemfile.lock will be created to lock down the gem versions used in this project.

#### Executing Ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

It's great for mock or development servers or for very simple projects.

We can create a web server in a single file.

https://sinatrarb.com/

## Terratowns Mock Server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb 
```

All of the code for our server is stored in the `server.rb` file.

## CRUD

Terraform Provider resources utilize CRUD.

CRUD stands for **C**reate, **R**ead, **U**pdate and **D**elete.

https://en.wikipedia.org/wiki/Create,_read,_update_and_delete

### Terratowns Provider Physical Diagram

![image](https://github.com/f616/terraform-beginner-bootcamp-2023/assets/3826426/481451fe-dccc-42ff-b465-75c2f68cd372)

### Anatomy of a HTTP Request

![image](https://github.com/f616/terraform-beginner-bootcamp-2023/assets/3826426/fbf50932-0b24-47d4-a196-90f574fb64b6)


