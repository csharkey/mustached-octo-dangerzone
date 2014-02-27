require 'apachelogregex'
require 'user_agent_parser'

module WeblogStats

    LOG_FMT  = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
    DATE_FMT = '[%d/%b/%Y:%H:%M:%S %Z]'
    SECONDS_IN_DAY = 24 * 3600
    TOP_N = 10
    FREQ_MAPS = %w{requestors paths browsers crawlers responses}

    class LogStats

        # @param format [String] same format as Apache mod_log_config
        #
        def initialize(format=LOG_FMT)
            @format       = format
            @stats        = {}
            reset_statistics

            @log_parser = ApacheLogRegex.new(@format)
            @ua_parser  = UserAgentParser::Parser.new
            @ua_cache   = Hash.new { |h,k| h[k] = @ua_parser.parse(k) }
        end

        # @param parsed [Hash] as per ApacheLogRegex#parse
        #
        def update_statistics(parsed)
            @num_requests += 1
            ts = DateTime.strptime(parsed['%t'], DATE_FMT)
            @first_ts = ts unless @first_ts
            @last_ts = ts

            @requestors[parsed['%h']] += 1
            @paths[parsed['%r'].split[1]] += 1
            @responses[parsed['%>s']] += 1

            ua = @ua_cache[parsed['%{User-Agent}i']]
            if ua.device.name == 'Spider'
                @crawlers[ua.name] += 1
            else
                @browsers[ua.name] += 1
            end
        end

        # @param parsed [String] single line from Apache log
        #
        def analyze_line(line)
            parsed = @log_parser.parse(line)
            if ! parsed
                @unparsed << line
                return
            end
            update_statistics(parsed)
        end

        # @param fd [File] stream to parse
        #
        def analyze_fd(fd)
            fd.each { |line|
                analyze_line(line)
            }
        end

        def reset_statistics
            @unparsed     = []
            @num_requests = 0

            FREQ_MAPS.each { |key|
                instance_variable_set('@' + key, Hash.new(0))
            }
        end

        # @param n [Integer,nil] Truncate stats to top N if non-nil
        # @return [Hash] each key represents a stat
        #
        def generate_statistics(n=TOP_N)
            @stats = {}

            FREQ_MAPS.each { |key|
                sorted = instance_variable_get('@' + key).sort_by { |k,v| v }
                sorted = sorted[-n..-1] if n && n > 0 && sorted.size > n
                @stats[key] = sorted.reverse
            }

            @stats[:unparsed] = @unparsed.size
            period_in_seconds = if @first_ts
                ((@last_ts - @first_ts) * SECONDS_IN_DAY).to_f
            else
                1
            end
            @stats[:total_requests] = @num_requests
            @stats[:mean_requests_per_sec] = (@num_requests / period_in_seconds).round(4)

            return @stats
        end

        # @param stats [Hash] stats to display as returned by #generate_statistics
        #
        def pretty_print(stats=@stats)
            puts 'general'
            (stats.keys - FREQ_MAPS).each { |header|
                puts "%20s  %s" % [stats[header], header]
            }
            FREQ_MAPS.each { |header|
                puts header
                puts
                stats[header].each { |k,v|
                    puts "%20d  %s" % [v, k]
                }
            }
        end
    end
end
