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

# Create a path to the SQL file in the Chef cache.
create_tables_script_path = File.join(Chef::Config[:file_cache_path], 'create-tables.sql')

connection_params = {
  :username => node['database']['root_username']
  :password => node['database']['server_root_password']
}

mysql_database node['database']['dbname'] do
  connection connection_params
  action :create
end

mysql_database_user node['database']['admin_username'] do
  connection connection_params
  password node['database']['admin_password']
  database_name node['database']['dbname']
  privileges [:all]
  action [:create, :grant]
end
   
# Write the SQL script to the filesystem.
cookbook_file create_tables_script_path do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
end
# Seed the database with a table and test data.
execute 'initialize my_company database' do
  command "mysql -h #{node['database']['host']} -u #{node['database']['admin_username']} -p#{node['database']['admin_password']} -D #{node['database']['dbname']} < #{create_tables_script_path}"
  not_if  "mysql -h #{node['database']['host']} -u #{node['database']['admin_username']} -p#{node['database']['admin_password']} -D #{node['database']['dbname']} -e 'describe customers;'"
end
   
 

