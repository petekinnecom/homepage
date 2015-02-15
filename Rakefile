require_relative './builder/articles_compiler'

namespace :server do
  desc "Start the server, bro"
  task :start do
    puts 'Server runs on port: 9080'
    puts '---'
    exec 'cd build && ruby -run -ehttpd . -p 9080'
  end
end

namespace :assets do
  desc "compile some assets"
  task :compile do
    `mkdir -p build/assets`
    `browserify node_modules/app/app.js -o build/assets/app.js`
    `browserify spec/spec_manifest.js -o test_site/compiled_specs.js`
     Rake::Task["assets:compile_articles"].invoke
  end

  task :compile_articles do
    `cp -R site/articles build/articles`

    articles = Dir.chdir('site/articles/chunks') do
      Dir.glob('*.html')
    end

    ArticlesCompiler.compile(articles, template: 'site/index.html')

  end

end
