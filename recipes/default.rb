#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
Mysql script to check and start the service
include_recipe 'mysql::server'
include_recipe 'mysql::ruby'

include_recipe 'database'
connection_params = {
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database 'my_db' do
  connection connection_params
  action :create
end

mysql_database_user 'Pankaj' do
  connection connection_params
  password 'my_password_11'
  privileges [:all]
  action [:create, :grant]
end
