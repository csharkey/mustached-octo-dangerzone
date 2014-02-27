require 'test/unit'
require 'weblog_stats'
require 'yaml'

class WeblogStatsTest < Test::Unit::TestCase
    def test_access_log_stats
        logstat = WeblogStats::LogStats.new
        logstat.analyze_fd(open('test/access.log'))
        stats = logstat.generate_statistics
        assert_equal(stats, YAML.load_file('test/access_stats.yml'))
    end
end
