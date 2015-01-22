class MainPage < AePageObjects::Document

  element :title, locator: ".article h1"
  element :terminal, locator: ".terminal", is: Terminal
end
