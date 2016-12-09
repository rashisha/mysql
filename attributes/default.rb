=begin
def random_password
  require 'securerandom'
  SecureRandom.base64
end
=end

default['firewall']['allow_ssh'] = true
default['firewall']['firewalld']['permanent'] = true
default['open_ports'] = 80

default['user'] = 'web_admin'
default['group'] = 'web_admin'
default['document_root'] = '/var/www/customers/public_html'

normal_unless['database']['root_password'] = 'root'
normal_unless['database']['admin_password'] = 'pankaj123'
default['database']['dbname'] = 'UserDB'
default['database']['host'] = '127.0.0.1'
default['database']['root_username'] = 'root'
default['database']['admin_username'] = 'pankaj'
normal_unless['database']['admin_password'] = 'pankaj123'