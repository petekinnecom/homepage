require 'page_objects/terminal'

class MainPage < AePageObjects::Document

  element :title, locator: ".main-screen-turn-on h1"
  element :terminal, locator: ".terminal", is: Terminal
end
