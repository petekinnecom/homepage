class Terminal < AePageObjects::Element
  class InputView < AePageObjects::Element
    def caret_char
      node.find('.caret').text
    end

    def type(*keys)
      keys.each do |key|
        node.native.send_keys(key)
      end
    end

    def run(string)
      type(string)
      type(:enter)
    end
  end

  element :input, locator: ".terminal-input", is: InputView
  collection :outputs, locator: "div.terminal-output", item_locator: "p"
end
