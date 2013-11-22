package "git-core" # apt-get install git-core
package "zsh"
package "nginx"

user node[:user][:name] do
  password node[:user][:password]
  gid "sudo"
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/zsh"
end

template "/home/#{node[:user][:name]}/.zshrc" do
  source "zshrc.erb"
  owner node[:user][:name]
end

directory "/home/#{node[:user][:name]}/example" do
  owner node[:user][:name]
end

file "/home/#{node[:user][:name]}/example/index.html" do
  owner node[:user][:name]
  content "<h1>Hello World</h1>"
end

include_recipe "nginx"

nginx_site "example" do
  template "nginx/example.conf.erb"
  action :enable
end

# p node[:nginx][:dir]
# p '---'

# file "#{node[:nginx][:dir]}/sites-available/example" do
#   content "server { root /home/#{node[:user][:name]}/example; }"
# end

# nginx_site "example"

service 'nginx' do
  supports [:status]
  action :start
end
