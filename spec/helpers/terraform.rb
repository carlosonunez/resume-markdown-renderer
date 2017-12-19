# frozen_string_literal: true

module RSpecHelpers
  module Terraform
    def self.initialize
      unless File.exist?('terraform.tfplan.json')
        raise 'Terraform plan JSON not found.'
      end
      JSON.parse(File.read('terraform.tfplan.json'))
    end

    # I'm not sure why this is triggering this cop. I'm guessing that
    # this has something to do with the RSpec verbs.
    # Therefore, I'm disabling it for now.
    # rubocop:disable Metrics/AbcSize
    def self.run_tests(resource_name:,
                       requirements_hash:)
      RSpec.describe 'Given a repository of Terraform configurations',
                     terraform: true do
        context "When I define \"#{resource_name}\"" do
          it 'It should not be empty' do
            expect(@terraform_plan[resource_name]).not_to be nil
          end
          requirements_hash.each_key do |requirement|
            test_name = requirements_hash[requirement][:test_name]
            if test_name.downcase.match?(/^it should/)
              example_name = test_name
            else
              warn '[WARN] ' \
                "Test name is not in 'It-should' format: #{test_name}".cyan
              example_name = 'It should have a correct ' \
                "#{resource_name}.#{requirement}"
            end
            it example_name do
              expected_value = requirements_hash[requirement][:should_be]
              actual_value = @terraform_plan[resource_name][requirement.to_s]
              matcher = if requirements_hash[requirement].key?(:matcher_type)
                          requirements_hash[requirement][:matcher_type]
                        else
                          :string
                        end
              case matcher
              when :json
                expected_json = expected_value
                actual_json = JSON.parse(actual_value)
                expect(expected_json).to eq actual_json
              else
                expect(expected_value.to_s).to eq actual_value.to_s
              end
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
