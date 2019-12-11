# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'ip21'
  s.summary     = 'Aspentech IP21 Adapter for Ruby'
  s.description = 'Aspentech IP21 Adapter for executing queries using SQLPlus' \
                  ' REST API'
  s.version     = '1.0.2'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.author      = 'Rhuan Barreto'
  s.email       = 'rhuan@rhuan.com.br'
  s.homepage    = 'http://rubygems.org/gems/ip21'
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.add_dependency 'activesupport', '~>6.0.1'
  s.add_dependency 'ruby-ntlm', '~>0.0.4'
  s.files = Dir.glob('{docs,bin,lib,spec,templates,benchmarks}/**/*') +
            ['LICENSE', 'README.md', '.yardopts', __FILE__]
  s.require_path = 'lib'
end
