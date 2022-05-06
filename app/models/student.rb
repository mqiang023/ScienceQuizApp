class Student < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods
  include AppHelpers::Validations
  

  # Relationships
  belongs_to :organization
  has_many :student_teams
  has_many :teams, through: :student_teams
  has_many :student_quizzes
  has_many :quizzes, through: :student_quizzes

  # Scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :juniors, -> { where('grade < 7') }
  scope :seniors, -> { where('grade > 6') }
  scope :for_organization, ->(organization) { where(organization_id: organization.id) }

  # Validations
  validates_presence_of :first_name, :last_name, :grade, :organization_id
  validates_numericality_of :grade, greater_than: 2, less_than: 13, only_integer: true
  validate -> { is_active_in_system(:organization) }, on: :create

  # Methods
  def name
    "#{last_name}, #{first_name}"
  end
  
  def proper_name
    "#{first_name} #{last_name}"
  end

  def junior?
    grade < 7
  end

  def current_team
    curr_team = self.student_teams.current    
    return nil if curr_team.empty?
    curr_team.first.team   # return as a single object, not an array
  end

  # Callbacks
  before_update do
    terminate_inactive_students
  end

  before_destroy do 
    check_if_ever_part_of_quiz
    if errors.present?
      @destroyable = false
      throw(:abort)
    else
      remove_current_teams
    end
   end

   after_rollback :convert_to_inactive

   private
   def check_if_ever_part_of_quiz
    unless no_quizzes?
      errors.add(:base, "Student cannot be destroyed as they have participated in a quiz.")
    end
  end

  def no_quizzes?
    self.quizzes.empty?
  end

  def remove_current_teams
    self.student_teams.current.each{ |m| m.destroy }
  end

  def convert_to_inactive
    if !@destroyable.nil? && @destroyable == false
      self.update_attribute(:active, false)
      remove_current_teams
    end
    @destroyable = nil
  end

  def terminate_inactive_students
    if self.active == false
      remove_current_teams
    end
  end


end
