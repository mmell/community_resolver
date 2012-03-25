module CommunityResolver
  class Engine < Rails::Engine

    config.after_initialize {
      require Rails.root.join( 'lib', 'community_resolver', 'resolver_authority')
    }

  end
end
