require 'selenium_helper'

class TerminalTest < PortfolioSeleniumTest

  attr_accessor :page; private :page

  def test_loads_page
    assert_equal "Article A", page.title.text

    page.terminal.input.run("article b")
    assert_equal "Article B", page.title.text

    assert_equal "Routing to article b", page.terminal.outputs.last.text
  end

  def test_moves_caret
    input = page.terminal.input

    #TODO: show caret on page load
    #assert_equal '', input.caret_char
    input.type('abc')
    assert_equal '', input.caret_char

    input.type(:left)
    assert_equal 'c', input.caret_char

    #input.arrow(:left)
    #assert_equal 'b', input.caret_char

    #input.type('b')

    # Should be this, but I think we get
    # a refocus event, so we're out of luck
    # The caret is moved to the end on refocus
    # and it doesn't work :(
    #assert_equal 'a', input.caret_char
    #assert_equal 'ba', input.text

    input.type(:up)
    assert_equal 'a', input.caret_char

    input.type(:enter)
    assert_equal '', input.text
  end

  private

  def setup
    @page = visit('/')
  end

end
