require "test_helper"

class UserScopeTest < ActiveSupport::TestCase
  # Context
  context "Given context" do
    setup do 
      create_organizations
      create_users
      create_teams
      create_events
      create_quizzes
      create_team_quizzes
    end

  # YOUR SCOPE TEST CODE HERE
  should "return active users" do
    assert_equal [@ed, @ralph, @cindy, @sophie, @ben, @kathryn, @alex], User.active.to_a
  end

  should "return inactive users" do
    assert_equal [@chuck], User.inactive.to_a
  end

  should "list users alphabetically by user's last name and first name" do
    assert_equal [@cindy, @ed, @alex, @kathryn, @sophie, @ben, @chuck, @ralph], User.alphabetical.to_a
  end

  end
end