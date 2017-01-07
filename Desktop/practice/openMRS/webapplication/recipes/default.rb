#
# Cookbook:: webapplication
# Recipe:: default
#
# Copyright:: 2016, The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'java'
#include_recipe 'mysql'
#include_recipe 'mysql2_chef_gem'

package node['webapp']['install'] do
  action :install
end

service node['webapp']['install'] do
  action :start
end

cookbook_file '/var/lib/tomcat7/webapps/openmrs.war' do
  source 'openmrs.war'
  mode '0755'
  action :create
end

ruby_block 'filesizelimit' do
  block do
    file = Chef::Util::FileEdit.new('/var/lib/tomcat7/webapps/openmrs/WEB-INF/web.xml')
    file.search_file_replace_line('<max-file-size>52428800<\\/max-file-size>','<max-file-size>104857600</max-file-size>')
    file.search_file_replace_line('<max-request-size>52428800<\\/max-request-size>','<max-request-size>104857600</max-request-size>')
    file.write_file
  end
end

execute '/var/lib/tomcat7/webapps/openmrs/*' do
  command 'sudo chmod -R 0755 /var/lib/tomcat7/webapps/openmrs/*'
  action :run
end

service node['webapp']['install'] do
  action :restart
end

mysql_client 'default' do
  action :create
end

mysql_service 'default' do
  port '3306'
  bind_address '0.0.0.0'
  initial_root_password 'openmrs123'
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

