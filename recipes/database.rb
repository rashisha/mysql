# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password node['database']['root_password']
  action [:create, :start]
end
package 'mysql-devel' do
end

# Install the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
  action :install
end

# Create the database instance.
mysql_database node['database']['dbname'] do
  connection(
    :host => node['database']['host'],
    :username => node['database']['root_username'],
    #:password => node['database']['root_password']
  )
  action :create
end

# Add a database user.
mysql_database_user node['database']['admin_username'] do
  connection(
    :host => node['database']['host'],
    :username => node['database']['root_username'],
   # :password => node['database']['root_password']
  )
  password node['database']['admin_password']
  database_name node['database']['dbname']
  host node['database']['host']
  action [:create, :grant]
end

# Create a path to the SQL file in the Chef cache.
create_tables_script_path = File.join(Chef::Config[:file_cache_path], 'create-tables.sql')

# Write the SQL script to the filesystem.
cookbook_file create_tables_script_path do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
end

# Seed the database with a table and test data.
execute "initialize #{node['database']['dbname']} database" do
  command "mysql -h #{node['database']['host']} -u #{node['database']['admin_username']} -p#{node['database']['admin_password']} -D #{node['database']['dbname']} < #{create_tables_script_path}"
  not_if  "mysql -h #{node['database']['host']} -u #{node['database']['admin_username']} -p#{node['database']['admin_password']} -D #{node['database']['dbname']} -e 'describe customers;'"
end