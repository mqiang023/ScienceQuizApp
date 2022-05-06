class StudentQuiz < ApplicationRecord
  include AppHelpers::Validations

  # Relationships
  belongs_to :quiz
  belongs_to :student
  validates_presence_of :student_id, :quiz_id, :num_correct, :num_attempted
  validates_numericality_of :num_correct, :greater_than_or_equal_to => 0, :less_than => 5, :only_integer => true
  validates_numericality_of :num_attempted, :greater_than_or_equal_to => 0, :less_than => 7, :only_integer => true

  # Scopes
  scope :by_student,  -> { joins(:student).order('last_name, first_name') }
  scope :by_quiz, -> { joins(:quiz).order('round', 'room') }
  scope :by_score, -> { order(:score) }
  scope :for_student,   ->(student) { where(student: student) }
  scope :for_quiz,   ->(quiz) { where(quiz: quiz) }

  # Validations
  validate :student_in_team_quiz

  # Callbacks
  before_update :calculate_score
  before_create :calculate_score

  private

  # Custom validation, checks if the student is on a team that participated in the quiz
  def student_in_team_quiz
    if (!self.student.nil?)
      teams = TeamQuiz.all.map{ |v| v.team }
      unless teams.include?(student.current_team)
        errors.add(:student_quiz, "student not part of teams in quiz")
      end
    end
  end

  # Callback method to calculate the student's score for a respective quiz
  def calculate_score
    # calculate number of incorrect answers
    num_wrong = self.num_attempted - self.num_correct

    # only the 2nd and 3rd errors get penalized, subtracting 10 points for each error made
    if num_wrong > 1 && num_wrong < 4
      self.score = self.score - ((num_wrong-1)*10)
    end

    # for each correct question, a student receives 20 points
    self.score = self.score + (num_correct*20)

    # if a student 'quizzes out' with a perfect score, they get a 10 point bonus
    if (self.num_attempted == self.num_correct) && (self.num_correct >= 4)
      self.score = self.score + 10
    end
  end

  
end
