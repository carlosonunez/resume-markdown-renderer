# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'resume_app'
require 'rack/test'
require 'aws-sdk-s3'
require 'colorize'
require 'dotenv'
Dotenv.load('.env.example')

require 'rspec/shell/expectations'
require './spec/helpers/terraform/terraform'
require './spec/helpers/terraform/terraform_plan'
require './spec/helpers/terraform/terraform_test'
require './spec/helpers/environment'
require './spec/helpers/json'

RSpec.configure do |configuration|
  configuration.before(:all, terraform: true) do |_example|
    @terraform_plan = RSpecHelpers::Terraform.initialize
  end
end
