# ruby -I"lib:test" "test/unit/resolve_test.rb"

require 'test_helper'
require 'community_resolver'
require 'community_resolver/proxy_response'

class ResolveTest < ActiveSupport::TestCase

  test "plus" do
    assert_equal('%2B', CGI::escape('+'))
  end

  test "parse_param_attributes" do
    arg = "_xrd_r=application/xrd%2Bxml;sep=false;ref=true"
    params = CommunityResolver::ProxyResponse.parse_param_attributes(arg)
    assert_equal('application/xrd+xml', params['_xrd_r'])
    assert_equal('false', params['sep'])
    assert_equal('true', params['ref'])

    arg = "_xrd_r=application/xrds%2Bxml;sep=false;ref=true"
    params = CommunityResolver::ProxyResponse.parse_param_attributes(arg)
    assert_equal('application/xrds+xml', params['_xrd_r'])
    assert_equal('false', params['sep'])
    assert_equal('true', params['ref'])

  end

  test "get_params" do
    env = { 'QUERY_STRING' => "_xrd_r=application/xrds%2Bxml" }
    assert_equal("_xrd_r=application/xrds+xml", CGI.unescape(env['QUERY_STRING']))

    params = CommunityResolver::ProxyResponse.parse_param_attributes(env['QUERY_STRING'])
    assert_equal('application/xrds+xml', params['_xrd_r'])

    params = CommunityResolver::ProxyResponse.get_params(env)
    assert_equal('application/xrds+xml', params['_xrd_r'])
    assert_equal(nil, params[:ref])

    env = { 'QUERY_STRING' => "_xrd_r=application/xrd%2Bxml;sep=true;ref=false" }
    params = CommunityResolver::ProxyResponse.get_params(env)
    assert_equal('application/xrd+xml', params['_xrd_r'])
    assert_equal('true', params['sep'])
    assert_equal('false', params['ref'])

    env = { 'QUERY_STRING' => "_xrd_r=application/xrds%2Bxml&_xrd_t=http://openid.net/signon/2.0" }
    params = CommunityResolver::ProxyResponse.get_params(env)
    assert_equal('application/xrds+xml', params['_xrd_r'])
    assert_equal('http://openid.net/signon/2.0', params['_xrd_t'])
  end

end
