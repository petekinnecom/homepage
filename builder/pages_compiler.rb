require_relative './template'
require_relative './page'

#TODO: This file is very MVP
class PagesCompiler < Struct.new(:pages, :template)

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

    default_page = Page.new('html/pages/articles/chunks/welcome.html', output_path: 'build/index.html')
    default_page.compile(template)
  end

end
