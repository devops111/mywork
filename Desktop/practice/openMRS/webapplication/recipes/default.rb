#
# Cookbook:: webapplication
# Recipe:: default
#
# Copyright:: 2016, The Authors, All Rights Reserved.
include_recipe 'java'

package 'tomcat7' do
  action :install
end

service 'tomcat7' do
  action :start
end

cookbook_file '/var/lib/tomcat7/webapps/openmrs.war' do
  source 'openmrs.war'
  mode '0755'
  action :create
end
service 'tomcat7' do
  action :restart
end