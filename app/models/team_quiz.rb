class TeamQuiz < ApplicationRecord
  include AppHelpers::Validations

  # Relationships
  belongs_to :quiz
  belongs_to :team

  # Validations
  validates_presence_of :quiz
  validates_numericality_of :raw_score, :only_integer => true, :allow_nil => true
  validates_numericality_of :team_points, :greater_than_or_equal_to => 0, :only_integer => true, :allow_nil => true
  validates_inclusion_of :position, :in =>[1,2,3]
  validate -> { is_active_in_system(:team) }, on: :create
  validate -> { is_active_in_system(:quiz) }
  validate :no_repeat_positions
  validate :no_repeat_teams

  # Scopes
  scope :by_team, -> { joins(:team).order('name') }
  scope :by_quiz, -> { joins(:quiz).order('round', 'room') }
  scope :by_position,   -> { order(:position) }
  scope :by_team_points, ->{ order('team_points DESC')}
  scope :for_team,   ->(team) { where(team: team) }
  scope :for_quiz,   ->(quiz) { where(quiz: quiz) }

  private
  # Custom Validation Test B
  def no_repeat_positions
    team_quizzes = TeamQuiz.all.map{ |v| v}
    specific_team_quizzes = []
    team_quizzes.each do |tq|
      if tq.quiz == self.quiz
        specific_team_quizzes.push(tq)
      end
    end

    positions_array = []
    specific_team_quizzes.each do |team_quizz|
      positions_array.push(team_quizz.position)
    end

    if positions_array.include?(self.position)
      errors.add(:team_quiz, "team quiz position already taken")
    end
  end

  # Custom Validation Test C & E
  def no_repeat_teams
    team_quizzes = TeamQuiz.all.map{ |v| v }
    specific_team_quizzes = []

    team_quizzes.each do |tq|
      if tq.quiz == self.quiz
        specific_team_quizzes.push(tq)
      end
    end

    teams_array = []
    specific_team_quizzes.each do |team_quizz|
      teams_array.push(team_quizz.team)
    end

    if teams_array.include?(self.team)
      errors.add(:team_quiz, "team already part of a team quiz")
    end

  end
end
