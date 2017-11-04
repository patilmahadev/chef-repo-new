#
# Cookbook:: tomcat
# Recipe:: utilities
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package ['wget', 'telnet', 'curl'] do
  action :install
end
