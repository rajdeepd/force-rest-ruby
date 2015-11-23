$LOAD_PATH << '.'

require 'json'
require 'pp'
require 'util'
require 'net/http'


# access_token = Util.get_access_token()

# uri = URI('https://ap2.salesforce.com/services/data/v34.0/sobjects/Account/')
# http = Net::HTTP.new(uri.host, uri.port)
# request = Net::HTTP::Get.new(uri.request_uri)
# http.use_ssl = true

# #'Authorization': 'Bearer ' + access_token
# request.initialize_http_header({"Authorization" => "Bearer " + access_token}) 
# response = http.request(request)
# parsed_response =  JSON.parse(response.body)
# pp parsed_response

response = Util.get_sobject_list('Account')
pp response


