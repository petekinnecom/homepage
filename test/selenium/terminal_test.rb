require 'selenium_helper'

class TerminalTest < PortfolioSeleniumTest

  attr_accessor :page; private :page

  def test_loads_page
    page.terminal.input.run("article koutouki")

    assert_equal "Routing to article koutouki", page.terminal.outputs.last.text
    assert_equal "Koutouki.org", page.title.text
  end

  def test_moves_caret
    input = page.terminal.input

    assert_equal '', input.caret_char
    input.type('abc')
    assert_equal '', input.caret_char

    input.type(:left)
    assert_equal 'c', input.caret_char

    input.type(:left)
    assert_equal 'b', input.caret_char

    input.type('d')

    # Should be this, but I think we get
    # a refocus event, so we're out of luck
    # The caret is moved to the end on refocus
    # and it doesn't work :(
    assert_equal 'b', input.caret_char
    assert_equal 'adbc', input.text

    input.type(:right)
    assert_equal 'c', input.caret_char

    input.type(:right)
    assert_equal '', input.caret_char

    # TODO: implement up
    #input.type(:up)
    #assert_equal 'a', input.caret_char

    input.type(:enter)
    assert_equal '', input.text
  end

  def test_backspace
    input = page.terminal.input

    input.type('abc')
    assert_equal '', input.caret_char

    input.type(:backspace)
    assert_equal 'ab', input.text
    assert_equal '', input.caret_char

    input.type(['d', :left, :backspace])
    assert_equal 'ad', input.text
  end

  def test_delete
    input = page.terminal.input

    input.type('abcd')
    assert_equal '', input.caret_char

    input.type(:delete) #no-op, since caret at the end
    assert_equal 'abcd', input.text
    assert_equal '', input.caret_char

    input.type(:left, :left, :delete)
    assert_equal 'abd', input.text
    assert_equal 'd', input.caret_char

    input.type(:delete)
    assert_equal 'ab', input.text
    assert_equal '', input.caret_char
  end

  private

  def setup
    @page = visit('/')
  end

end
