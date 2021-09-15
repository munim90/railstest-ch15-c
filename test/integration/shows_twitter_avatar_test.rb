require "test_helper"

class TaskShowsTwitterAvatar < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers

  setup do
    projects(:bluebook).roles.create(user: users(:user))
    users(:user).update_attributes(twitter_handle: "noelrap")
    tasks(:one).update_attributes(user_id: users(:user).id,
                                  completed_at: 1.hour.ago)
    login_as users(:user)
  end

  test "I see a gravatar" do
    VCR.use_cassette("loading_twitter") do
      visit project_path(projects(:bluebook))
      url = "http://pbs.twimg.com/profile_images/1371552537153781764/77cdD1px_bigger.jpg"
      within("#task_1") do
        assert_selector(".completed", text: users(:user).email)
        assert_selector("img[src='#{url}']")
      end
    end
  end
end