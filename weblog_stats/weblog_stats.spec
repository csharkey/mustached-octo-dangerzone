Gem::Specification.new do |s|
    s.name        = 'weblog_stats'
    s.version     = '0.0.1'
    s.date        = '2014-02-26'
    s.license     = 'MIT'

    s.summary     = 'Apache Web Log Stats'
    s.description = 'Analyze Apache access.log and produce statistics'

    s.email       = 'csharkey@example.com'
    s.homepage    = 'https://github.com/csharkey/mustached-octo-dangerzone'
    s.authors     = ['Cillian Sharkey']

    s.files       = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
    s.executables = ['weblog_stats']

    s.add_dependency 'apachelogregex',    '>= 0.1.0'
    s.add_dependency 'user_agent_parser', '>= 2.1.0'

    s.rubyforge_project = "weblog_stats"
end
