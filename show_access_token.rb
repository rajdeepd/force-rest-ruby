$LOAD_PATH << '.'

require 'json'
require 'pp'
require 'util'


result = Util.get_access_token()
parsed = JSON.parse(result) 
pp parsed
