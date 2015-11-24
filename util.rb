require 'net/http'
require 'yaml'
require 'json'

module Util
	def Util.get_access_token()
		credentials = YAML.load(File.open("./config.yml"))['credentials']
		uri = URI('https://ap2.salesforce.com//services/oauth2/token')
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true

		res = Net::HTTP.post_form(uri, 'grant_type' => 'password',
			                           'client_id' => credentials['client_id'],
		                               'client_secret' => credentials['client_secret'],
		                               'username' => credentials['username'],
		                               'password' => credentials['password'])
		result = res.body
		parsed = JSON.parse(result) 
        access_token = parsed['access_token']
		return access_token
	end

	def Util.get_sobject_list(object_name)
		access_token = Util.get_access_token()

		uri = URI('https://ap2.salesforce.com/services/data/v34.0/sobjects/'+ object_name)
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
		http.use_ssl = true

		#'Authorization': 'Bearer ' + access_token
		request.initialize_http_header({"Authorization" => "Bearer " + access_token}) 
		response = http.request(request)
		parsed_response =  JSON.parse(response.body)
		return parsed_response
	end

	def Util.create_sobject(object_name, data)
		access_token = Util.get_access_token()

		uri = URI('https://ap2.salesforce.com/services/data/v34.0/sobjects/'+ object_name)
		puts uri
		http = Net::HTTP.new(uri.host, uri.port)

		request = Net::HTTP::Post.new(uri.request_uri)
		http.use_ssl = true
		request.initialize_http_header({"Authorization" => "Bearer " + access_token}) 
		request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        name = ''
        if object_name == 'Account'
        	name = data['name']
        end
        if name != ''
	        request.body = {
	  			"name" => name
				}.to_json    
			puts request.body
			res = http.request(request)
		
			return res
		else
			puts 'name not defined'
			return Nil
		end
	end
end