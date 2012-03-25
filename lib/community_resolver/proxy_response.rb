require 'community_resolver/response'

module CommunityResolver

  # provide the XRDS for a Proxy request
  #
  class ProxyResponse < CommunityResolver::Response

    def initialize(iname, action, env)
      @is_cacheable = false # because of the many query args possible
      @action, @env = action, env
      @xri = get_iname(iname)
      @params = ProxyResponse.get_params(@env)
      @sep = !(@params['sep'] == 'false')
      @xrd_only = ("#{@params['_xrd_r']}" =~ CommunityResolver::XrdParamRE)
    end

    def render_xrds(xri)
      if @xrd_only
        render_xrd(xri)
      else
        segments = xri.segments.dup
        current = AtLinksafe::Xri.get(segments.shift)
        render_xrd(current)
        segments.each { |e|
          current = AtLinksafe::Xri.get(current.compose, e)
          render_xrd(current)
        }
      end
    end

    def client_status(valid)
      if valid
        %Q{<Status cid="verified" code="100">SUCCESS</Status>\n  }
      else
        %Q{<Status cid="off" code="222">The subsegment does not exist</Status>\n  }
      end
    end

    def self.get_params(env)
      if env['HTTP_ACCEPT'] and (env['HTTP_ACCEPT'].index('application/xrd'))
        self.parse_param_attributes(env['HTTP_ACCEPT'])
      else
        self.parse_param_attributes(env['QUERY_STRING'])
      end
    end

    def self.parse_param_attributes(query_string)
      hsh = CGI::parse(query_string)
      secondary_hsh = {}
      hsh.each { |k,v|
        next if v.nil?
        v = v.first # v is an array!?
        secondary_args = v.split(';')
        hsh[k] = secondary_args.shift
        next if secondary_args.empty?
        secondary_args.each { |one_pair|
          pair = one_pair.split('=')
          secondary_hsh[pair[0]] = pair[1]
        }
      }
      secondary_hsh.merge!(hsh)
    end

  end
end
