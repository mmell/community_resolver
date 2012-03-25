require 'test_helper'
require 'at_linksafe/iname'

# Proxy Responses DO contain the parent XRD
#
class MetalProxyTest < ActionController::IntegrationTest

  BaseCid = '@!72CD.A072.157E.A9C6'
  Path = CommunityResolver::Path::Proxy

  def setup
    @authority = Factory.create(:authority, :canonical_id => BaseCid)
    assert(@authority.valid?)
    @authority.synonyms.create!(:synonym => '@llli')
    assert_kind_of(CommunityResolver::ResolverAuthority, CommunityResolver::ResolverAuthority.find_authority('@llli') )

    @authority = Factory.create(:authority, :canonical_id => Authority.new_canonical_id(BaseCid))
    @synonym = '@llli*mike'
    @authority.synonyms.create(:synonym => @synonym)
  end

  def test_basic
    get("/#{Path}/#{@synonym}")
    assert(@response.body.index("<XRD"), @response.body)
    assert(!@response.body.index("<XRDS"), @response.body)
    assert(@response.body.index("<CanonicalID>#{BaseCid}</CanonicalID>"), @response.body)
    assert(@response.body.index("<CanonicalID>#{@authority.canonical_id}</CanonicalID>"), @response.body)
  end

  def test_splitiname
    get("/#{Path}/#{@synonym.sub('*', '/*')}")
    assert(@response.body.index("<XRD"), @response.body)
    assert(!@response.body.index("<XRDS"), @response.body)
    assert(@response.body.index("<CanonicalID>#{@authority.canonical_id}</CanonicalID>"), @response.body)
  end

  def test_xrd
    get("/#{Path}/#{@synonym}", {:_xrd_r => "application/xrd+xml;sep=false;ref=true"})
    assert(@response.body.index("<XRD"), @response.body)
    assert(!@response.body.index("<XRDS"), @response.body)
    assert(!@response.body.index("<CanonicalID>#{BaseCid}</CanonicalID>"), @response.body)
    assert(@response.body.index("<CanonicalID>#{@authority.canonical_id}</CanonicalID>"), @response.body)
  end

  def test_xrd_escaped
    get("/#{Path}/#{@synonym}", {:_xrd_r => "application/xrd%2Bxml;sep=false;ref=true"})
    assert(@response.body.index("<XRD"), @response.body)
    assert(!@response.body.index("<XRDS"), @response.body)
    assert(!@response.body.index("<CanonicalID>#{BaseCid}</CanonicalID>"), @response.body)
    assert(@response.body.index("<CanonicalID>#{@authority.canonical_id}</CanonicalID>"), @response.body)
  end

  def test_xrds
    get("/#{Path}/#{@synonym}", {:_xrd_r => "application/xrds+xml;sep=false;ref=true"})
    assert(@response.body.index("<XRD"), @response.body)
    assert(@response.body.index("xrds:XRDS"), @response.body)
    assert(@response.body.index("<CanonicalID>#{BaseCid}</CanonicalID>"), @response.body)
    assert(@response.body.index("<CanonicalID>#{@authority.canonical_id}</CanonicalID>"), @response.body)
  end

  def test_xrds_escaped
    # DummyResAuthEndpoint must be running (the dev server)
    iname, cid = '@llli*mike.mell', '@!72CD.A072.157E.A9C6!0000.0000.3B9A.CA17'
    url= "#{DummyResAuthEndpoint}/#{Path}/#{iname}?_xrd_r=application/xrds%2Bxml;sep=false;ref=true"
    response = AtLinksafe::UriLib::fetch_uri(url)
    assert(response.body.index("<XRD"), response.body)
    assert(response.body.index("xrds:XRDS"), response.body)
    assert(response.body.index("<CanonicalID>#{BaseCid}</CanonicalID>"), response.body)
    assert(response.body.index("<CanonicalID>#{cid}</CanonicalID>"), response.body)
    assert(!response.body.index("<Service"), response.body)
  end

  def test_xrds_escaped_with_sep
    get("/#{Path}/#{@synonym}", {:_xrd_r => "application/xrds%2Bxml;sep=true;ref=true"})
    assert(@response.body.index("<XRD"), @response.body)
    assert(@response.body.index("xrds:XRDS"), @response.body)
    assert(@response.body.index("<CanonicalID>#{BaseCid}</CanonicalID>"), @response.body)
    assert(@response.body.index("<CanonicalID>#{@authority.canonical_id}</CanonicalID>"), @response.body)
    assert(@response.body.index("<Service"), @response.body)
  end

  def test_subsegment_does_not_exist
    get("/#{Path}/@llli*doesnotexist")
    assert(@response.body.index('<ServerStatus code="222">'), @response.body)
  end

end
