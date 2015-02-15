#TODO: This file is very MVP
class PagesCompiler < Struct.new(:pages, :template)


  class Template < Struct.new(:filename)
    def lines_for(page)
      [].tap do |new_lines|
        lines.each do |line|
          # remove the manual embedding, so that the automatic one doesn't write it twice
          new_lines << line.gsub("<!--\* #{page.reference} -->", '').gsub('<!-- container -->', "<!--** #{page.reference} -->")
        end
      end
    end

    private

    def lines
      File.open(filename, 'r').readlines
    end
  end

  class Page < Struct.new(:input_path, :output_path)

    def initialize(input_path, output_path: nil)
      super(input_path, output_path || input_path.sub(/chunks/, '').sub(/^site/, 'build'))
    end

    def name
      File.basename(input_path)
    end

    def reference
      page_dir = input_path.match(/\/([^\/]+)\/chunks/)[1]
      File.join(page_dir, name)
    end

    def compile(template)
      template_lines = template.lines_for(self)
      new_lines = []

      template_lines.each do |line|
        match = line.match(/<!--\*(?<visible>\*?) (?<page>(.*)) -->/) #eg: <!--* page_name -->

        if match
          visible = match[:visible].length > 0
          file_name = File.basename(match[:page])
          dir_name = File.dirname(match[:page])
          file_path = File.join('site/pages', dir_name, 'chunks', file_name)

          page_name = match[:page].gsub(/\.html$/, '')
          div_open  =  %{<div data-page-name="#{page_name}" style="display: #{visible ? "block" : "none"};">}
          div_close = "</div>"

          page_contents = File.read(file_path).gsub(/\r/, '').gsub(/\n/, '')

          new_lines << [div_open, page_contents, div_close].join('')
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

  def self.compile(pages, template:)
    new(pages, template).compile
  end

  def initialize(page_filenames, template_filename)
    template = Template.new(template_filename)
    pages = page_filenames.map {|a| Page.new(a) }

    super(pages, template)
  end

  def compile
    pages.each do |page|
      page.compile(template)
    end

    default_page = Page.new('site/articles/chunks/welcome.html', output_path: 'build/index.html')
    default_page.compile(template)
  end


end
