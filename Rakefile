
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
    `browserify node_modules/app/app.js -o build/assets/app.js`
    `browserify spec/spec_manifest.js -o test_site/compiled_specs.js`
    `cp -R site/articles build/articles`
     Rake::Task["assets:compile_index"].invoke
  end

  task :compile_index do
    read_file = File.open('site/index.html', 'r')
    new_lines = []

    read_file.each_line do |line|
      match = line.match(/<!--\* (.*) -->/) #eg: <!--* article_name -->

      if match
        file_name = match[1]
        article_name = match[1].gsub(/\.html$/, '')
        div_open  =  %{<div data-article-name="#{article_name}" style="display: none;">}
        div_close = "</div>"

        article_contents = File.read("site/articles/chunks/#{file_name}").gsub(/\r/, '').gsub(/\n/, '')

        new_lines << [div_open, article_contents, div_close].join('')
      else
        new_lines << line
      end
    end

    read_file.close

    File.open('build/index.html', 'w') do |f|
      new_lines.each do |line|
        f.puts line
      end
    end
  end

  #task :compile_articles do
  #  template_lines = File.open('site/index.html', 'r').readlines
  #  articles = Dir.glob('site/articles/*.html')

  #  articles.each do |article|
  #    File.open('build/
  #  end

  #end

end
