require 'community_resolver'

Rails.application.routes.draw do
  match "/:action/*xri", :to => ResolveController.action(:respond), :constraints => {
    :action => /#{CommunityResolver::Path::Authority}|#{CommunityResolver::Path::Proxy}/
  }
end
