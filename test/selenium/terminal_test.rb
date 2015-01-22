require 'selenium_helper'

class TerminalTest < PortfolioSeleniumTest

  def test_loads_page
    @page = visit('/')
    require 'pry';binding.pry

    assert_equal "Article A", page.title.text
  end

  def reload
    load "/Users/pete/Dropbox/pete/code/current_projects/portfolio/test/page_objects/main_page.rb"
    load "/Users/pete/Dropbox/pete/code/current_projects/portfolio/test/page_objects/terminal.rb"
    @page = visit('/')
  end
end
