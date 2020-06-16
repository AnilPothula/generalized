default['elasticsearch']['repo']['url'] = "https://artifacts.elastic.co/packages/7.x/apt"
default['elasticsearch']['repo']['gpg'] = "https://artifacts.elastic.co/GPG-KEY-elasticsearch"

default['elasticsearch']['cluster_name'] = "elasticsearch"

default['elasticsearch']['heap_size'] = "#{node['memory']['total'][/\d*/].to_i / 1024 * 60 / 100}M"

default['elasticsearch']['is_master'] = true
default['elasticsearch']['is_data']   = true
