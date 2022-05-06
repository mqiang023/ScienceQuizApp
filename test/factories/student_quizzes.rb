FactoryBot.define do
  factory :student_quiz do
    quiz { @acac_e1_s1_r1 }
    student { @lydia }
    score { 0 }
    num_attempted { 1 }
    num_correct { 1 }
  end
end
