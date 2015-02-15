class ArticlesCompiler < Struct.new(:articles, :template)

  def self.compile(articles, template:)
    new(articles, template).compile
  end

  def compile
    template_lines = File.open('site/index.html', 'r').readlines

    articles.each do |article|
      process("build/articles/#{article}", specified_template(template_lines, article))
    end

    process("build/index.html", specified_template(template_lines, 'welcome.html'))
  end

  def process(file, template_lines)
    new_lines = []

    template_lines.each do |line|
      match = line.match(/<!--\*(?<visible>\*?) (?<article>(.*)) -->/) #eg: <!--* article_name -->

      if match
        visible = match[:visible].length > 0
        file_name = match[:article]
        article_name = match[:article].gsub(/\.html$/, '')
        div_open  =  %{<div data-article-name="#{article_name}" style="display: #{visible ? "block" : "none"};">}
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
        new_lines << line.gsub("<!--\* #{article_path} -->", '').gsub('<!-- container -->', "<!--** #{article_path} -->")
      end
    end
  end
end
