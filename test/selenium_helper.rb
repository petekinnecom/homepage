require "minitest/autorun"
require "mocha/test_unit"
require 'capybara'
require "ae_page_objects"
require 'pry'

Dir[File.dirname(__FILE__) + '/page_objects/**/*.rb'].each {|file| require file }

Capybara.default_driver = :selenium

module SeleniumHelpers
  TEST_URL = "http://localhost:9080"

  def visit(path)
    Capybara.visit([TEST_URL, path].join(""))
    MainPage.new
  end
end

class PortfolioSeleniumTest < MiniTest::Test

  include SeleniumHelpers
end
