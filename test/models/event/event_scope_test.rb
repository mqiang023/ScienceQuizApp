require "test_helper"

class EventScopeTest < ActiveSupport::TestCase
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
  should "returns active events" do
    assert_equal [@acac_e1, @acac_e2, @acac_e3, @millvale_e1], Event.active.to_a
  end

  should "returns inactive events" do
    assert_equal [@uniontown_e1], Event.inactive.to_a
  end

  should "list events by date" do
    assert_equal [@acac_e2, @acac_e1, @millvale_e1, @acac_e3, @uniontown_e1], Event.chronological.to_a
  end

  should "returns events that happened in the past" do
    assert_equal [@acac_e1, @acac_e2, @millvale_e1], Event.past.to_a
  end

  should "returns events that are today or in the future" do
    assert_equal [@acac_e3, @uniontown_e1], Event.upcoming.to_a
  end

  should "list events for a given organization" do
    assert_equal [@acac_e1, @acac_e2, @acac_e3], Event.for_organization(@acac)
  end

end
end