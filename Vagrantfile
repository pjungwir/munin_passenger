# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/xenial64"
  # config.vm.box_version = '0.1.0'

  config.ssh.forward_agent = true
  config.omnibus.chef_version = '12.18.31'

  config.vm.define "app" do |host|
    host.vm.network :private_network, ip: "192.168.60.10"
    host.vm.provider :virtualbox do |vb|
      vb.name = "munin_with_passenger"
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  config.vm.provision :shell, inline: <<-EOS
set -eu

sudo apt-get update

# nginx
sudo apt-get install -y nginx

# passenger
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
sudo apt-get install -y nginx-extras passenger
sudo tee /etc/nginx/nginx.conf <<EOF
user www-data;
worker_processes 2;
pid /run/nginx.pid;

events {
  worker_connections 768;
}

http {
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;
  # server_tokens off;

  # server_names_hash_bucket_size 64;
  # server_name_in_redirect off;

  include /etc/nginx/mime.types;
  default_type application/octet-stream;

  ##
  # SSL Settings
  ##

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
  ssl_prefer_server_ciphers on;

  ##
  # Logging Settings
  ##

  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  ##
  # Gzip Settings
  ##

  gzip on;
  gzip_disable "msie6";

  # gzip_vary on;
  # gzip_proxied any;
  # gzip_comp_level 6;
  # gzip_buffers 16 8k;
  # gzip_http_version 1.1;
  # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

  ##
  # Phusion Passenger config
  ##
  # Uncomment it if you installed passenger or passenger-enterprise
  ##

  include /etc/nginx/passenger.conf;
  passenger_max_pool_size 4;
  passenger_pool_idle_time 300;
  passenger_pre_start http://127.0.0.1/;
  passenger_user_switching off;
  passenger_default_user www-data;
  passenger_default_group www-data;

  limit_req_zone \\$binary_remote_addr zone=one:10m rate=20r/s;

  ##
  # Virtual Host Configs
  ##

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}
EOF

sudo tee /etc/nginx/sites-available/rails <<EOF
server {
  listen 80 default_server;
  server_name _;

  root /vagrant/example/public;
  try_files \\$uri @passenger;

  location @passenger {
    rails_env production;
    passenger_enabled on;
    passenger_min_instances 4;
    limit_req zone=one burst=5;
  }
}
EOF
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/rails /etc/nginx/sites-enabled/

# munin
sudo add-apt-repository -y ppa:hawq/munin
sudo apt-get update
sudo apt-get install -y munin munin-node
sudo tee /etc/nginx/sites-available/munin <<EOF
server {
  listen 7778;
  root /var/cache/munin/www;
}
EOF
sudo ln -s /etc/nginx/sites-available/munin /etc/nginx/sites-enabled/

# postgres
sudo apt-get install -y postgresql postgresql-contrib
sudo su - postgres -c "psql -c \\"CREATE USER rails WITH PASSWORD 'rails';\\""
sudo su - postgres -c "psql -c \\"CREATE DATABASE rails WITH OWNER rails;\\""

# rails
cd /vagrant/example
sudo gem install bundler
sudo apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev nodejs
sudo bundle install --system
RAILS_ENV=production bundle exec rake db:migrate

# my plugin
the_gem=`ls -t /vagrant/pkg/*.gem | head -1`
if [ ! -z "$the_gem" ]; then
  sudo gem install /vagrant/pkg/`ls /vagrant/pkg/ | head -1`
fi
sudo munin_passenger-install
sudo tee /etc/munin/plugin-conf.d/passenger <<EOF
[passenger_*]
user root
env.PASSENGER_ROOT /usr/sbin
EOF
sudo service munin-node restart
sudo service nginx restart
  EOS
end
