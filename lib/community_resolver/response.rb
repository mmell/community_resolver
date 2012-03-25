module CommunityResolver

  # base implementation for Authority and Proxy XRDS requests
  #
  class Response

    def self.new_response(iname, action, env)
      case action
      when CommunityResolver::Path::Authority
        CommunityResolver::AuthorityResponse.new(iname, action, env)
      when CommunityResolver::Path::Proxy
        CommunityResolver::ProxyResponse.new(iname, action, env)
      end
    end

    def get_iname(iname)
      AtLinksafe::Xri.get(iname.sub('/', '' ) )
    end

    def generate
      @response = %Q{<?xml version="1.0" encoding="UTF-8"?>\n<xrds:XRDS xmlns:xrds="xri://$xrds" xmlns="xri://$xrd*($v*2.0)">\n}
      render_xrds(@xri)
      @response << '</xrds:XRDS>'
      cache if @is_cacheable and Rails.env.production? and @found
    end

    def render
      generate
      @response
    end

    def expires
      Time.now.utc + 1.month
    end

    def local_id(cid)
      cid[cid.rindex('!')..-1]
    end

    def provider_id(cid)
      cid[0...cid.rindex('!')]
    end

    def get_xrd(xri)
      @found = CommunityResolver::ResolverAuthority.find_authority(xri.compose) # ResolverAuthority implemented in the main app
      if @found
        %Q{<XRD xmlns="xri://$xrd*($v*2.0)">
  <Query>*#{xri.segment}</Query>
  #{client_status(true)}<ServerStatus code="100">SUCCESS</ServerStatus>
  <Expires>#{expires.xmlschema(0)}</Expires>
  <ProviderID>xri://#{provider_id(@found.canonical_id)}</ProviderID>
  <LocalID>#{local_id(@found.canonical_id)}</LocalID>
  <CanonicalID>#{@found.canonical_id}</CanonicalID>#{@sep ? @found.services : ''}
</XRD>
}
      else
        %Q{<XRD xmlns="xri://$xrd*($v*2.0)">
  <Query>*#{xri.segment}</Query>
  #{client_status(false)}<ServerStatus code="222">The subsegment does not exist</ServerStatus>
  <Expires>#{expires.xmlschema}</Expires>
  <ProviderID>xri://#{xri.parent}</ProviderID>
</XRD>
}
      end
    end

    def render_xrd(xri)
      @response << get_xrd(xri)
    end

  end
end
