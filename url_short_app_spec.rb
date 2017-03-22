require 'minitest/autorun'
require "./long_url"

describe LongUrl do
  before do
    @long_url= LongUrl.new('url'=>'www.google.com')
    LongUrl.store << @long_url
  end

  describe "get url" do
   it "returns url instance from short url" do
     @long_url.url.must_equal LongUrl.get_url('short_url',@long_url.short_url).url
   end

   it "returns url instance from original url" do
     @long_url.url.must_equal LongUrl.get_url('url',@long_url.url).url
   end
  end

  describe "list all urls" do
    it "returns all urls with its short url" do
      {@long_url.url=>@long_url.short_url}.must_equal LongUrl.get_all_urls
    end
  end

  describe "Check short url" do
    it "returns E0 for first id 1912 by the shortening algorithm" do
      @long_url.id = 1912
      @long_url.short_url.must_equal "shor.ty/"+@long_url.send(:generate_short_url)
    end
  end


  describe "Initialize" do
   it "raises You need to provide url" do
     assert_raises ArgumentError do
       LongUrl.new
     end
   end
 end
end
