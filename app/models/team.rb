class Team < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods
  include AppHelpers::Validations
  include AppHelpers::Deletions

  DIVISION_LIST = [['Junior', 'junior'],['Senior', 'senior']].freeze

  # Relationships
  belongs_to :organization
  has_many :student_teams
  has_many :students, through: :student_teams
  has_many :team_quizzes
  has_many :quizzes, through: :team_quizzes
  belongs_to :coach, class_name: "User"

  # Scopes
  scope :alphabetical, -> { order(:name) }
  scope :by_division, -> { order(:division) }
  scope :for_organization, ->(organization) { where(organization_id: organization.id) }
  scope :juniors, -> { where(division: 'junior') }
  scope :seniors, -> { where(division: 'senior') }

  # Validations
  validates_presence_of :name, :division, :organization_id
  validates_inclusion_of :division, in: %w[senior junior], message: 'is not a valid division'
  validate -> { is_active_in_system(:organization) }, on: :create

  # Other methods
  def junior?
    self.division == 'junior'
  end

  #Callbacks
  before_destroy do 
    check_if_ever_participate_in_quiz
    if errors.present?
      @destroyable = false
      throw(:abort)
    else
      self.destroy
    end
   end

   def check_if_ever_participate_in_quiz
    unless no_quizzes?
      errors.add(:base, "Team cannot be deleted as it has participated in a quiz")
    end
  end

  def no_quizzes?
    self.quizzes.empty?
  end


end
