
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
    `browserify node_modules/app.js -o site/assets/app.js`
    `browserify spec/spec_manifest.js -o test_site/compiled_specs.js`
  end
end
