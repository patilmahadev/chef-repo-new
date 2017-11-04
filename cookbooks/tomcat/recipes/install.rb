#
# Cookbook:: tomcat
# Recipe:: install
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['os'] == 'linux'

  package 'java-1.7.0-openjdk' do
    action :install
  end

  tomcat_pkg = File.basename(URI.parse(node['tomcat']['tar_source']).path)
  tomcat_dir = tomcat_pkg[/apache-tomcat-\d+\.\d+\.\d+/]

  remote_file "#{node['tomcat']['root_dir']}/#{tomcat_pkg}" do
    source node['tomcat']['tar_source']
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  bash 'untar tomcat' do
    cwd '/opt'
    code <<-EOH
      tar -xf #{tomcat_pkg}
    EOH
    action :run
    not_if { ::File.exists?("#{node['tomcat']['root_dir']}/#{tomcat_dir}") }
  end

  bash 'start tomcat' do
    cwd "#{node['tomcat']['root_dir']}/#{tomcat_dir}/bin"
    code <<-EOH
      sh startup.sh
    EOH
    action :run
    not_if 'netstat -nlp | grep 8080'
  end

else
  puts "This cookbook is not supported on #{node['os']}."
end
