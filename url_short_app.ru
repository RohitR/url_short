require 'json'
require './long_url'

class ShortUrlAPI
  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
      when /set_url/
        case request.request_method
          when 'POST'
            begin
              long_url = LongUrl.new(request.params)
            rescue LongUrl::InvalidParams => error
              [400, {"Content-Type" => "text/plain"}, [error.message] ]
            else
              LongUrl.store << long_url
              [200, {"Content-Type" => "text/plain"}, ["Url added, currently #{LongUrl.store.size} urls are in memory!"]]
            end
          when 'GET'
            [200, { 'Content-Type' => 'application/json' }, [ LongUrl.get_all_urls.to_json ]]
          else
            [404, {}, ["Did you get lost?"]]
          end
      when  /get_url/
        redirect=LongUrl.get_url('url',request.path_info.gsub("/get_url/", ""))
        unless redirect.nil?
          [200, { 'Content-Type' => 'application/json' }, [ {:url=>redirect.url,:short_url=>redirect.short_url}.to_json ]]
        else
          redirect_url('/urls/set_url')
        end
      else
        redirect=LongUrl.get_url('short_url',request.path_info[1..-1])
        unless redirect.nil?
          redirect="http://#{redirect.url}"
        else
          redirect='/urls/set_url'
        end
        redirect_url(redirect)
      end
    end

    def redirect_url(path)
      res = Rack::Response.new
      res.redirect(path)
      res.finish
    end
  end

  map '/urls' do
    run ShortUrlAPI.new
  end
