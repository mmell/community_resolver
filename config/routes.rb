require 'community_resolver'

Rails.application.routes.draw do
  match "/:action/*xri", :to => ResolveController.action(:respond), :constraints => {
    :action => /#{CommunityResolver::Path::Authority}|#{CommunityResolver::Path::Proxy}/
  }, :format => false # format false allows dots in inames
end
