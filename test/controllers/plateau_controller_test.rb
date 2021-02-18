require 'test_helper'

class PlateauControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get plateau_index_url
    assert_response :success
  end

end
