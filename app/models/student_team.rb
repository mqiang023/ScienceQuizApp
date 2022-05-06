class StudentTeam < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods
  include AppHelpers::Validations

  # Relationships
  belongs_to :student
  belongs_to :team

  # Scopes
  scope :by_position,   -> { order(:position) }
  scope :alphabetical,  -> { joins(:student).order('last_name, first_name') }
  scope :chronological, -> { order(:start_date) }
  scope :for_team,      ->(team) { where('team_id =?', team.id) }
  scope :for_student,   ->(student) { where(student: student) }
  scope :captains,      -> { where(position: 1) }
  scope :current,       -> { where('end_date IS NULL') }
  scope :past,          -> { where('end_date IS NOT NULL') }

  # Validations
  validates_presence_of :start_date, :position, :student_id, :team_id
  validates_numericality_of :position, greater_than: 0, less_than: 6, only_integer: true
  validates_date :start_date, on_or_before: ->{ Date.current }, on_or_before_message: "cannot be in the future"
  validates_date :end_date, on_or_after: :start_date, on_or_before: ->{ Date.current }, allow_blank: true
  validate -> { is_active_in_system(:student) }, on: :create
  validate -> { is_active_in_system(:team) }, on: :create

  validate :check_same_org
  validate :no_repeat_positions
  validate :division_match
  validate :unique_student_team

  # Other methods
  def terminate_now
    current_assignment = self.student.student_teams.current.first
    if current_assignment.nil?
      return true 
    else
      current_assignment.end_date = Date.current
      current_assignment.update_attribute(:end_date, Date.current)
    end
  end

  # Callbacks
  before_create :end_previous_team_assignment

  private
  def end_previous_team_assignment
    current_assignment = self.student.student_teams.current.first
    if current_assignment.nil?
      return true 
    else
      current_assignment.update_attribute(:end_date, self.start_date.to_date)
    end
  end

  # Custom Validation Test A
  def check_same_org
    if self.student != nil
      if self.team != nil
        if self.student.organization != self.team.organization
          errors.add(:student_team, "student does not have same organization as team")
        end
      end
    end
  end

  # Custom Validation Test B
  def no_repeat_positions
    student_teams = StudentTeam.all.map{ |v| v}
    specific_student_teams = []

    student_teams.each do |t|
      if (t.team == self.team) && (t.student != self.student)
        specific_student_teams.push(t)
      end
    end

    positions_array = []
    specific_student_teams.each do |s|
      positions_array.push(s.position)
    end

    if (positions_array.include?(self.position))
      errors.add(:student_team, "position already taken")
    end
  end

  # Custom Validation Test C & D
  def division_match
    if self.student != nil
      if self.team != nil
        if (self.student.junior? && !self.team.junior?) || (!self.student.junior? && self.team.junior?)
          errors.add(:student_team, "divisions for student and team are not the same")
        end
      end
    end
  end

  # Custom Validation Test E
  def unique_student_team
    student_teams = StudentTeam.all.map{ |v| v}
    specific_student_teams = []

    student_teams.each do |t| 
      if self.end_date == nil && t.end_date == nil
        specific_student_teams.push(t)
      end
    end

    specific_student_teams.each do |s|
      if self.team == s.team
        if self.student == s.student
          if self.position != s.position
            errors.add(:student_team, "not valid")
          end
        end
      end
    end

  end
end
