$LOAD_PATH << '.'

require 'json'
require 'pp'
require 'util'
require 'net/http'

class AccountList
  def get
    response = Util.get_sobject_list('Account')
    pp response
  end
end

accountList = AccountList.new
accountList.get



