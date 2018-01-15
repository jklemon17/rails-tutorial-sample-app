require 'test_helper'

Rails.application.routes.default_url_options[:host] = 'test.host'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,          "Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Help"),  "Help | Ruby on Rails Tutorial Sample App"
  end
end
