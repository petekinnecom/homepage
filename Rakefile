require 'sprockets'

namespace :server do
  desc "Start the server, bro"
  task :start do
    puts 'Server runs on port: 9080'
    puts '---'
    exec 'cd site && ruby -run -ehttpd . -p 9080'
  end
end

namespace :assets do
  desc "compile some assets"
  task :compile do
    environment = Sprockets::Environment.new
    environment.append_path 'assets/javascripts'
    environment.find_asset('app').write_to('site/assets/app.js')
  end
end
