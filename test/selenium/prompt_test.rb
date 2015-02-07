require 'selenium_helper'

class PromptTest < PortfolioSeleniumTest

  attr_accessor :page; private :page

  def test_loads_page
    page.terminal.input.run("article koutouki")

    assert_eventually_equal "Loaded article koutouki", proc { page.terminal.outputs.last.text }
    assert_eventually_equal "Koutouki.org", proc { page.title.text }
  end

  def test_moves_caret
    input = page.terminal.input
    input.node.click

    assert_eventually_equal '', proc { input.caret_char }
    input.type('abc')
    assert_equal '', input.caret_char

    input.type(:left)
    assert_equal 'c', input.caret_char

    input.type(:left)
    assert_equal 'b', input.caret_char

    input.type('d')

    assert_equal 'b', input.caret_char
    assert_equal 'adbc', input.text

    input.type(:right)
    assert_equal 'c', input.caret_char

    input.type(:right)
    assert_equal '', input.caret_char

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

  def test_history_of_input
    input = page.terminal.input

    input.type('first')
    input.type(:enter)
    assert_eventually_equal '', proc { input.text }
    assert input.visible?, "Wait until it reappears"

    input.type('second')
    input.type(:enter)
    assert_eventually_equal '', proc { input.text }
    assert input.visible?, "Wait until it reappears"


    input.type('third')
    input.type(:enter)
    assert_eventually_equal '', proc { input.text }
    assert input.visible?, "Wait until it reappears"

    input.type(:up)
    assert_equal 'third', input.text
    input.type(:up)
    assert_equal 'second', input.text
    input.type(:up)
    assert_equal 'first', input.text

    input.type(:down)
    assert_equal 'second', input.text
    input.type(:down)
    assert_equal 'third', input.text
    input.type(:down)
    assert_equal '', input.text
  end

  private

  def setup
    @page = visit('/')
    @page.terminal.input.node.click

    #ensure all the animations have finished
    assert_eventually_equal true, proc {@page.terminal.outputs.visible?}
    assert_eventually_equal 'Routing to default article', proc { @page.terminal.outputs.last.text }
    assert_eventually_equal '', proc { @page.terminal.input.text }
  end

end
