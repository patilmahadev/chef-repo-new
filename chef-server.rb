server_name = "ip-10-10-1-9.ec2.internal"
api_fqdn = server_name
bookshelf['vip'] = server_name
nginx['url'] = "https://#{server_name}"
nginx['server_name'] = server_name
lb['fqdn'] = server_name
#nginx['ssl_certificate'] = "/var/opt/opscode/nginx/ca/#{server_name}.crt"
#nginx['ssl_certificate_key'] = "/var/opt/opscode/nginx/ca/#{server_name}.key"
