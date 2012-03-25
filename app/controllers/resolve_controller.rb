require 'community_resolver'

class ResolveController < ActionController::Metal

  def respond
    self.content_type = "text/html"

    if params[:xri]
      ActiveRecord::Base.clear_active_connections! # http://blog.codefront.net/2009/06/15/activerecord-rails-metal-too-many-connections/
      authority = CommunityResolver::Response.new_response( CGI::unescape( params[:xri] ), params[:action], env)
      raise RuntimeError, "nothing found for #{CGI::unescape( params[:xri] )}" unless authority
      self.status = 200
      self.response_body = authority.render
    else
      self.status = 404
      self.response_body = "Not Found"
    end
  end

end
