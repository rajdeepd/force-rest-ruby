$LOAD_PATH << '.'
require 'pp'
require 'util'

data = Hash.new
data['name'] = "DHL"
response = Util.create_sobject('Account', data)
puts response.body