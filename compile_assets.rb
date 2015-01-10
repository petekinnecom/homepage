require 'pry'
require 'sprockets'

environment = Sprockets::Environment.new
environment.append_path 'assets/javascripts'

environment.find_asset('app').write_to('app.js')
