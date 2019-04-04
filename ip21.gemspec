Gem::Specification.new do |s|
  s.name = 'ip21'
  s.summary     = 'Aspentech IP21 Adapter for Ruby'
  s.description = 'Aspentech IP21 Adapter for executing queries using SQLPlus' \
                  'WebService or REST API'
  s.version     = '0.0.3'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.author      = 'Rhuan Barreto'
  s.email       = 'rhuan@rhuan.com.br'
  s.homepage    = 'http://rubygems.org/gems/ip21'
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.add_dependency 'ruby-ntlm'
  s.add_dependency 'rubyntlm'
  s.add_dependency 'savon'
  s.files = Dir.glob('{docs,bin,lib,spec,templates,benchmarks}/**/*') +
            ['LICENSE', 'README.md', '.yardopts', __FILE__]
  s.require_path = 'lib'
end
