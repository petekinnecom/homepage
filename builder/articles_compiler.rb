#TODO: This file is very MVP
class ArticlesCompiler < Struct.new(:articles, :template)

  class Template < Struct.new(:filename)
    def lines_for(article_name)
      [].tap do |new_lines|
        lines.each do |line|
          # remove the manual embedding, so that the automatic one doesn't write it twice
          new_lines << line.gsub("<!--\* #{article_name} -->", '').gsub('<!-- container -->', "<!--** #{article_name} -->")
        end
      end
    end

    private

    def lines
      File.open(filename, 'r').readlines
    end
  end

  class Article < Struct.new(:name, :output_path)

    def initialize(name, output_path: nil)
      super(name, output_path || "build/articles/#{name}")
    end

    def compile(template)
      template_lines = template.lines_for(name)
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

      File.open(output_path, 'w') do |f|
        new_lines.each do |line|
          f.puts line
        end
      end
    end
  end

  def self.compile(articles, template:)
    new(articles, template).compile
  end

  def initialize(article_filenames, template_filename)
    template = Template.new(template_filename)
    articles = article_filenames.map {|a| Article.new(a) }

    super(articles, template)
  end

  def compile
    articles.each do |article|
      article.compile(template)
    end

    default_article = Article.new('welcome.html', output_path: 'build/index.html')
    default_article.compile(template)
  end


end
