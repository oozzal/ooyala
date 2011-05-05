require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/sha2'
require 'net/http'
require 'rational'
require 'nokogiri'
require 'active_support'

%w{
  parsing
  formatting
  error
  request
  response
  query_request
  query_response
  custom_metadata_request
  custom_metadata_response
  attribute_update_request
  attribute_update_response
  thumbnail_query_request
  thumbnail_query_response
  query_iterator
  query_pager
  item
  thumbnail
  service
}.each do |file|
  require "#{ File.dirname( __FILE__ ) }/ooyala/#{ file }"
end

module Ooyala

  class << self
    attr_accessor :service
  end

end