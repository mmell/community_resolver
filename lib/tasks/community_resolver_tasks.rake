desc "community_resolver tasks"
namespace :community_resolver do

  desc "Clear out any and all public/resolve elements"
  task :flush_cached_xrds do
    `rm -rf #{CommunityResolver::AuthorityResponse.cache_path('*')}`
  end
end
