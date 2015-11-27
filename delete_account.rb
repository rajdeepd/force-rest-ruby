$LOAD_PATH << '.'
require 'pp'
require 'util'

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