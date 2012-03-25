module CommunityResolver

  # provide the XRDS for an authority request
  #
  class AuthorityResponse < CommunityResolver::Response

    def initialize(iname, action, env)
      @is_cacheable = true
      @action, @env = action, env
      @xri = get_iname(iname)
      @params = ProxyResponse.get_params(@env)
      @sep = !(@params['sep'] == 'false')
      #@sep = true
    end

    def render_xrds(xri)
      render_xrd(xri)
    end

    def client_status(valid)
      ''
    end

    def self.cache_path(xri)
      File.join(Rails.root, 'public', CommunityResolver::Path::Authority, xri.to_s)
    end

    def cache
      File.open( CommunityResolver::AuthorityResponse.cache_path(@xri), 'w' ) { |f|
        f.write(@response)
        f.close
      }
    end

  end
end
