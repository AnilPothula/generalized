#
# Cookbook:: elasticsearch
# Recipe:: setup
#
# Copyright:: 2017, The Authors, All Rights Reserved.

apt_update  'update'
apt_package 'openjdk-8-jre-headless'
apt_package 'apt-transport-https'
apt_package 'wget'

# temporary fix fo opsworks chef not adding the gpg key from apt_repository
bash 'name' do
  code <<-EOH
  wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
  EOH
  action :run
end

apt_repository 'elasticsearch' do
  uri "#{node['elasticsearch']['repo']['url']}"
  components ['main']
  distribution 'stable'
  key "#{node['elasticsearch']['repo']['gpg']}"
  action :add
end

apt_update  'update'
apt_package 'elasticsearch'

execute 'chown_elasticseach_mount' do
  command 'chown -R elasticsearch:elasticsearch /var/lib/elasticsearch'
  action :run
  only_if { ::Dir.exist?("/var/lib/elasticsearch") }
end

template '/etc/security/limits.conf' do
  source 'etc/security/limits.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end
