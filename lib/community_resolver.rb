require "community_resolver/engine"
require 'community_resolver/path'
require 'community_resolver/response'
require 'community_resolver/authority_response'
require 'community_resolver/proxy_response'
require 'community_resolver/abstract_interface'
require 'community_resolver/authority_interface'

module CommunityResolver
  XrdParamRE = Regexp.compile(/\Aapplication\/xrd[\s|\+|%]/) # "xrd+xml" or "xrd xml" or "xrd%20xml"

end
