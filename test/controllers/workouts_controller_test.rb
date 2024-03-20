require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get workouts_new_url
    assert_response :success
  end
end
