class Event < ApplicationRecord
    include AppHelpers::Activeable::InstanceMethods
    extend AppHelpers::Activeable::ClassMethods
    include AppHelpers::Validations

    # Relationships
    belongs_to :organization

    # Validations
    validates_presence_of :organization_id
    validates_date :date
    validate -> { is_active_in_system(:organization) }, on: :create

    # Scopes
    scope :active, ->{ where(active: true) }
    scope :inactive, ->{ where(active: false) }
    scope :chronological, -> { order('date') }
    scope :past, ->{ where('date < ?', Date.current) }
    scope :upcoming, ->{ where('date >= ?', Date.current) }
    scope :for_organization,  ->(organization) { where(organization: organization) }

    # Other Methods

    # Make an inactive event active
    def make_active
      self.active = true
      self.save!
    end 
    
    # Make an active event inactive
    def make_inactive
      self.active = false
      self.save!
    end

end
