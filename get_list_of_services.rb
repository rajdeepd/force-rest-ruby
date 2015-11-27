require 'net/http'
require 'json'
require 'pp'


class Services
  def list
	begin
	  uri = URI('http://ap2.salesforce.com/services/data/')
	  result = Net::HTTP.get(uri)
	  parsed = JSON.parse(result) 
	  pp parsed
	rescue Exception => e
	  puts e
	end
  end
end

services = Services.new
services.list
