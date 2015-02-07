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

  def assert_eventually_equal(expected_value, callable)
    values = []
    passed = AePageObjects::Waiter.wait_until(3) do
      current_value = callable.call
      values << current_value
      expected_value == current_value
    end

    if ! passed
      puts "Expected value: \"#{expected_value}\""
      puts "Acutal values: "
      p values.uniq
    end

    assert passed, "failed :("
  end
end

class PortfolioSeleniumTest < MiniTest::Test
  include SeleniumHelpers
end
