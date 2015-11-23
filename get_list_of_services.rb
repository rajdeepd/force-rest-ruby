require 'net/http'
require 'json'
require 'pp'

begin
  uri = URI('http://ap2.salesforce.com/services/data/')
  result = Net::HTTP.get(uri)
  parsed = JSON.parse(result) 
  pp parsed
rescue Exception => e
  puts e
end
