require 'securerandom'
class LongUrl

  attr_accessor :id, :url, :short_url
  ALPHABET =
  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)

  #set id for each object. Initial value set as 1912
  @last_id = 1912
  class << self
    attr_accessor :last_id
  end

  # Memory store, gets cleared as the process is restarted
  def self.store
    @urls ||= []
  end

  class InvalidParams < StandardError; end

  # create an instance based on some passed params
  def initialize(params)
    raise InvalidParams, "You need to provide url" unless params['url']
    self.url = params['url']
    self.id = LongUrl.last_id
    LongUrl.last_id = LongUrl.last_id+1
    self.short_url="shor.ty/"+generate_short_url
  end

  def self.get_url(url_type,get_url)
    return LongUrl.store.select{|url| url.send(url_type)==get_url}.first
  end

  def self.get_all_urls
    hsh={}
    store.each{|long_url| hsh.merge!(long_url.url=>long_url.short_url) }
    hsh
  end

  private

  def generate_short_url
    return ALPHABET[0] if self.id == 0
    s = ''
    base = ALPHABET.length
    while self.id > 0
      s << ALPHABET[self.id.modulo(base)]
      self.id /= base
    end
    s.reverse
  end

end
