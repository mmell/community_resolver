require 'community_resolver/authority_interface'

module CommunityResolver
  class ResolverAuthority < CommunityResolver::AuthorityInterface

    def self.find_authority(xri)
      @xri = xri
      if AtLinksafe::Iname.is_inumber?(xri)
        canonical_id = xri
      else
        authority = Authority.select(:canonical_id).includes(:synonyms).where(["synonyms.synonym = ? ", xri]).first
        canonical_id = authority.nil? ? nil : authority.canonical_id
      end
      if canonical_id
        new(canonical_id, xri)
      else
        nil
      end
    end

    def services
      openid + ( delegates_allowed? ? res_auth : '')
    end

    def openid
  %Q{
    <Service>
      <Type>http://specs.openid.net/auth/2.0/signon</Type>
      <Type>http://openid.net/signon/1.1</Type>
      <Type>http://openid.net/signon/1.0</Type>
      <URI>#{DummyOpenIdEndpoint}/server</URI>
      <LocalID>xri://#{@xri}</LocalID>
    </Service>}
    end

    def res_auth
  %Q{
    <Service>
      <Type select="true">xri://$res*auth*($v*2.0)</Type>
      <MediaType>application/xrds+xml;https=#{HTTPS == ' https://' ? 'true' : 'false' }</MediaType>
      <URI>#{DummyResAuthEndpoint}/resolve/#{@xri}/</URI>
    </Service>}
    end

    # in this Dummy (Test) environment we only allow one level of delegation
    #
    def delegates_allowed?
      @xri.index('*').nil?
    end

  end

end
