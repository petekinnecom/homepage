
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
     Rake::Task["assets:compile_articles"].invoke
  end

  task :compile_articles do
    `cp -R site/articles build/articles`

    Dir.chdir('site/articles/chunks')
    articles = Dir.glob('*.html')
    Dir.chdir('../../../')

    template_lines = File.open('site/index.html', 'r').readlines

    articles.each do |article|
      compile("build/articles/#{article}", specified_template(template_lines, article))
    end

    compile("build/index.html", specified_template(template_lines, 'welcome.html'))
  end

  def compile(file, template_lines)
    new_lines = []

    template_lines.each do |line|
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

    File.open(file, 'w') do |f|
      new_lines.each do |line|
        f.puts line
      end
    end
  end

  def specified_template(template_lines, article_path)
    [].tap do |new_lines|
      template_lines.each do |line|
        # remove the manual embedding, so that the automatic one doesn't write it twice
        new_lines << line.gsub("<!--\* #{article_path} -->", '').gsub('<!-- container -->', "<!--* #{article_path} -->")
      end
    end
  end

end
