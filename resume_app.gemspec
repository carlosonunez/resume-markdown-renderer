# frozen_string_literal: true

require 'digest/md5'

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
gem_author = ENV['GEM_AUTHOR']
gem_email = ENV['GEM_EMAIL']
require 'resume_app/version'

Gem::Specification.new do |spec|
  spec.name           = 'resume_app'
  spec.version        = ResumeApp::VERSION
  spec.authors        = [gem_author]
  spec.licenses = ['MIT']
  spec.email          = [gem_email]
  spec.summary        = 'A simple app that generates resumes from Markdown.'
  spec.description    = 'A simple app that generates resumes from Markdown.'
  spec.files          = Dir['{bin,lib}/**/*', 'LICENSE', 'README.md']
  spec.executables    = ['resume_app']
  spec.require_paths  = ['lib']
end
