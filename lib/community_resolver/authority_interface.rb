require 'community_resolver/abstract_interface'

# The Rails app that includes the CommunityResolver gem must implement the
#   AuthorityInterface as CommunityResolver::Authority
#

=begin
http://proxy.xri.net/@llli?_xrd_r=application/xrds+xml
http://proxy.xri.net/@llli?_xrd_r=application/xrd+xml
http://proxy.xri.net/@llli*mike?_xrd_r=application/xrds+xml
http://proxy.xri.net/@llli/*mike?_xrd_r=application/xrd+xml

http://0.0.0.0:3000/resolve/@llli?_xrd_r=application/xrds+xml
http://0.0.0.0:3000/resolve/@llli?_xrd_r=application/xrd+xml
http://0.0.0.0:3000/resolve/@llli*mike?_xrd_r=application/xrds+xml
http://0.0.0.0:3000/resolve/@llli/*mike?_xrd_r=application/xrd+xml
=end

module CommunityResolver
  class AuthorityInterface
    include AbstractInterface

    attr_reader :canonical_id, :xri

    # returns a new instance of AuthorityInterface
    #
    def self.find_authority(xri)
      api_not_implemented(self)
    end

    def initialize(canonical_id, xri)
      @canonical_id, @xri = canonical_id, xri
    end

    # returns a sting containing all of the appropriate Service elements
    #
    def services
      AuthorityInterface.api_not_implemented(self)
    end

    # returns a valid $res*auth*($v*2.0) Service element
    #
    def openid
      AuthorityInterface.api_not_implemented(self)
    end

    # returns a valid $res*auth*($v*2.0) Service element
    #
    def res_auth
      AuthorityInterface.api_not_implemented(self)
    end

    #   returns boolean if the @xri is allowed to delegate
    #
    def delegates_allowed?
      AuthorityInterface.api_not_implemented(self)
    end

  end

end
