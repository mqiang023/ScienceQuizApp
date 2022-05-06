require "test_helper"

class StudentQuizCallbackTest < ActiveSupport::TestCase
  # Context
  context "Given context" do
    setup do 
      create_organizations
      create_users
      create_students
      create_events
      create_quizzes
      create_teams
      create_student_teams
      create_team_quizzes
      create_student_quizzes
    end

  # YOUR CALLBACK TEST CODE HERE
  should "show that the student score has been calculated" do
    assert_equal 90, @ellie_acac_e1_s1_r1.score
    assert_equal 30, @anna_acac_e1_s1_r1.score
    assert_equal 80, @ellie_acac_e1_s1_r2.score
    assert_equal 20, @mj_acac_e1_j3_r1.score
  end

end
end
