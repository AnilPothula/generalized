#
# Cookbook:: elasticsearch
# Recipe:: configure
#
# Copyright:: 2017, The Authors, All Rights Reserved.

this_instance = search("aws_opsworks_instance", "self:true").first

master_nodes = []
search("aws_opsworks_instance", "role:master").each do |instance|
  master_nodes.push(instance['private_ip'])
end

data_nodes = []
search("aws_opsworks_instance", "role:data").each do |instance|
  data_nodes.push(instance['private_ip'])
end

if master_nodes.include?(this_instance['private_ip'])
  node.override['elasticsearch']['is_master'] = "true"
else
  node.override['elasticsearch']['is_master'] = "false"
end

if data_nodes.include?(this_instance['private_ip'])
  node.override['elasticsearch']['is_data'] = "true"
else
  node.override['elasticsearch']['is_data'] = "false"
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'etc/elasticsearch/elasticsearch.yml.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0644'
  variables lazy {{
    master_nodes: master_nodes,
    data_nodes: data_nodes,
    cluster_name: node['elasticsearch']['cluster_name'],
    node_name: 	this_instance["hostname"],
    rack_id: this_instance["availability_zone"]
  }}
  notifies :restart, 'service[elasticsearch]', :delayed
end

template '/etc/elasticsearch/jvm.options' do
  source 'etc/elasticsearch/jvm.options.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0644'
  variables lazy {{
    master_nodes: master_nodes,
    data_nodes: data_nodes,
    node_name: 	this_instance["hostname"],
    rack_id: this_instance["availability_zone"]
  }}
  notifies :restart, 'service[elasticsearch]', :delayed
end

template '/etc/elasticsearch/log4j2.properties' do
  source 'etc/elasticsearch/log4j2.properties.erb'
  owner 'root'
  group 'elasticsearch'
  mode '0644'
  variables lazy {{
    master_nodes: master_nodes,
    data_nodes: data_nodes,
    node_name: 	this_instance["hostname"],
    rack_id: this_instance["availability_zone"]
  }}
  notifies :restart, 'service[elasticsearch]', :delayed
end

template '/etc/default/elasticsearch' do
  source 'etc/default/elasticsearch.erb'
  owner 'root'
  group 'root'
  mode '0744'
  notifies :restart, 'service[elasticsearch]', :delayed
end

service 'elasticsearch' do
  provider Chef::Provider::Service::Systemd
  supports status: true
  action   [:enable, :start]
end
