# frozen_string_literal: true

vpc_requirements = {
  cidr_block: {
    test_name: 'It should be a variable',
    should_be: '10.0.0.0/16'
  },
  enable_dns_hostnames: {
    test_name: 'It should be true',
    should_be: true
  },
  enable_dns_support: {
    test_name: 'It should be true',
    should_be: true
  },
  'tags.version': {
    test_name: 'It should have a version tag',
    should_be: 'fake_version'
  }
}

internet_gateway_requirements = {
  vpc_id: {
    test_name: 'It should be a variable',
    should_be: '${aws_vpc.app.id}'
  },
  'tags.version': {
    test_name: 'It should have a version tag',
    should_be: 'fake_version'
  }
}

route_requirements = {
  destination_cidr_block: {
    test_name: 'It should point to the Internet CIDR',
    should_be: '0.0.0.0/0'
  },
  gateway_id: {
    test_name: 'It should point to the igw',
    should_be: '${aws_internet_gateway.app.id}'
  }
}

RSpecHelpers::Terraform.run_tests(resource_name: 'aws_vpc.app',
                                  tests: vpc_requirements)

RSpecHelpers::Terraform.run_tests(resource_name: 'aws_internet_gateway.app',
                                  tests: internet_gateway_requirements)

RSpecHelpers::Terraform.run_tests(
  resource_name: 'aws_route.app_outbound_internet',
  tests: route_requirements
)

%w[a b].each do |subnet_id|
  RSpecHelpers::Terraform.run_tests(
    resource_name: "aws_route_table_association.subnet_#{subnet_id}",
    tests: {
      subnet_id: {
        should_be: "${aws_subnet.subnet_#{subnet_id}.id}"
      },
      route_table_id: {
        should_be: '${data.aws_route_table.app_vpc.id}'
      }
    }
  )
end
