Overview
--------
This Repo provides samples on how to use Ruby to work with force.com REST APIs

Setup
======
Create a config.yml file from config_sample.yml file and fill in the values appropriately from salesforce developer account.

::

	$ cp config_sample.yml config.yml
	$ $ cat config_sample.yml 

Update the TODO with appropriate values for client_id, client_secret username and password.

::
	credentials:
	    client_id: TODO
            client_secret: TODO
            username: TODO
            password: TODO


Common Methods
==============
File `util.rb` provides common methods for getting access token as shown below

```ruby
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
```
