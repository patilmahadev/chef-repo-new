#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

sys_admin = data_bag_item('sysadmins','badal')

user sys_admin['id'] do
  uid sys_admin['uid']
  shell sys_admin['shell']
  comment sys_admin['comment']
end

if node['platform_family'] == 'amazon' || node['platform_family'] == 'rhel'

  package 'httpd' do
    action :install
  end
  
  template "#{node['apache']['doc_root']}/#{node['apache']['index']}" do
    source 'index.html.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :os => node['os'],
      :platform_family => node['platform_family'],
      :pri_ip => node['ec2']['local_ipv4'],
      :pub_ip => node['ec2']['public_ipv4']
    )
    notifies :restart, 'service[httpd]', :immediately
  end
  
  service 'httpd' do
    action [:enable, :start]
  end

elsif node['platform_family'] == 'debian'

  apt_update 'update' do
    action :update
  end

  package 'apache2' do
    action :install
  end

  template "#{node['apache']['doc_root']}/#{node['apache']['index']}" do
    source 'index.html.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :os => node['os'],
      :platform_family => node['platform_family'],
      :pri_ip => node['ec2']['local_ipv4'],
      :pub_ip => node['ec2']['public_ipv4']
    )
    notifies :restart, 'service[apache2]', :immediately
  end

  service 'apache2' do
    action [:enable, :start]
  end

else
  puts "This cookbook is not supported on #{node['platform_family']}."
end

