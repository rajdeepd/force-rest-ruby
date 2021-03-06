Overview
--------
This Repo provides samples on how to use Ruby to work with force.com REST APIs

Setup
======
Create a config.yml file from config_sample.yml file and fill in the values appropriately from salesforce.com developer account.

::

	$ cp config_sample.yml config.yml
	$ cat config_sample.yml 

Update the TODO with appropriate values for :code:`client_id`, :code:`client_secret`, :code:`username` and :code:`password`.

::

	credentials:
	    client_id: TODO
            client_secret: TODO
            username: TODO
            password: TODO


Common Methods
==============
File :code:`util.rb` provides common methods for getting access token. Getting access token consists of following steps. We define a class Util in this file and add common methods as static in this file

Get Access Token
^^^^^^^^^^^^^^^^

* Load Credentials from config.yml
* Connect to the OAuth2 token url
* Create a new HTTP object
* Do a secure HTTP Post to the url with the credentials 
* Get the result body and Parse it
* Extract the access_token and return it


.. code-block:: ruby

	def self.get_access_token()
		credentials = YAML.load(File.open("./config.yml"))['credentials']
		uri = URI(@@access_url)
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

Get List of SObjects
^^^^^^^^^^^^^^^^^^^^
Url used to make request depends on the instance where your account was created ( na1, na2, ap1, ap2 etc) as well the version of the API being used.
We are using the base url :code:`https://ap2.salesforce.com/services/data/v35.0/sobjects/`.

The function :code:`self.get_sobject_list(object_name)` takes the object name for which list has to be created (Account, Contact etc). A HTTPs Get request is made
to the URL listed above appended by the :code:`object_name`. Header of the HTTP request has Access token set


.. code-block:: ruby

    def self.get_sobject_list(object_name)
      access_token = Util.get_access_token

      uri = URI(@@base_url + object_name)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      http.use_ssl = true

      #'Authorization': 'Bearer ' + access_token
      request.initialize_http_header({"Authorization" => "Bearer " + access_token})
      response = http.request(request)
      parsed_response =  JSON.parse(response.body)
      return parsed_response
    end

Get Account List
================
We created a new method in :code:`util.rb` :code:`Util.get_sobject_list(object_name)`. In this method we get the access token from  :code:`Util.get_access_token()` and use it make a POST request to the url :code:`https://ap2.salesforce.com/services/data/v34.0/sobjects/Account`.

.. code-block:: ruby

    class AccountList
      def get
        response = Util.get_sobject_list('Account')
        pp response
      end
    end

accountList = AccountList.new
accountList.get

Execute the program, It will return the list of Accounts created in the salesforce.com instance.

::

	$ ruby get_account_list.rb

Create Account
==============
We added a new method in :code:`util.rb`, :code:`Util.create_sobject(object_name, data)`. This method takes two parameters. :code:`object_name` which is the sobject name we want to create, and :code:`data` which is data object to be sent in json format. 

Detailed steps

1.Get access token
 
  .. code-block:: ruby

	 access_token = self.get_access_token()


2. Create a URI object :code:`uri` based on the object_name

3. Create a new :code:`Net:HTTP` object based in the :code:`uri`

4. Create a POST request object

5. Make sure the http object is set to user ssl

6. Set up the request's header to include :code:`access_token` as shown below

  .. code-block:: ruby

      request.initialize_http_header({"Authorization" => "Bearer " + access_token})

7. Check for Object_Name to be of type :code:`Account`

8. Make a Post Request

   .. code-block:: ruby

      request.body = data.to_json
      res = http.request(request)
      return res

Full code Listing of the method

.. code-block:: ruby

	def self.create_sobject(object_name, data)
		access_token = Util.get_access_token()

		uri = URI(@@base_url + object_name)
		puts uri
		http = Net::HTTP.new(uri.host, uri.port)

		request = Net::HTTP::Post.new(uri.request_uri)
		http.use_ssl = true
		request.initialize_http_header({"Authorization" => "Bearer " + access_token}) 
		request['Content-Type'] = 'application/json'
		request['Accept'] = 'application/json'
		name = ''
		if object_name == 'Account'
			request.body = data.to_json
			res = http.request(request)
			return res
		else
			puts 'name not defined'
			return Nil
		end
	end

The method listed above is called as shown in the listing below in the file :code:`create_account.rb`

.. code-block:: ruby

  class CreateAccount
    def execute
      data = Hash.new
      data['name'] = "DHL1"
      response = Util.create_sobject('Account', data)
      puts response.body
    end
   end
  createAccount = CreateAccount.new
  createAccount.execute

Delete Account
==============
We created a new method in Util class, :code:`self.delete_sobject(object_name, object_id)` which takes the :code:`object_name` and :code:`object_id`
and makes a :code:`DELETE` method to the rest endpoint specified by :code:`@@base_url/<object_name>/<object_id>`

.. code-block:: ruby

	def self.delete_sobject(object_name, object_id)
		access_token = Util.get_access_token

		uri = URI(@@base_url + object_name + '/' + object_id)
		puts uri
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Delete.new(uri.request_uri)
		http.use_ssl = true
		request.initialize_http_header({"Authorization" => "Bearer " + access_token})
		res = http.request(request)
		return res
	end

This function is called in :code:`DeleteAccount` class execute method as shown below

.. code-block:: ruby

  class DeleteAccount
    def execute
      account_id = '0012800000AaIZi'
        sobject_name = 'Account'
        response = Util.delete_sobject(sobject_name, account_id)
        puts response
    end
  end
  deleteAccount = DeleteAccount.new
  deleteAccount.execute

Execute the code

::

  $ ruby delete_account.rb

