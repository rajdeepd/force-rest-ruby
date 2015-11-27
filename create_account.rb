$LOAD_PATH << '.'
require 'pp'
require 'util'

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