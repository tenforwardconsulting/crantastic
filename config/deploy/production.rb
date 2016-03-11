server 'ec2-52-37-210-5.us-west-2.compute.amazonaws.com', user: 'deploy', roles: %w{web app db}
set :branch, ENV['BRANCH'] || 'production'
