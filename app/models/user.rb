class User < ApplicationRecord
   include AppHelpers::Activeable::InstanceMethods
   extend AppHelpers::Activeable::ClassMethods
   include AppHelpers::Deletions
 
   # Use built-in rails support for password protection
   has_secure_password
  
   # Relationships
   has_many :teams, foreign_key: "coach_id"
   belongs_to :organization
 
   # Validations
   validates_presence_of :first_name, :last_name, :organization_id
   validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format"
   validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
   validates :username, presence: true, uniqueness: { case_sensitive: false }
   validates_presence_of :password, :on => :create 
   validates_presence_of :password_confirmation, :on => :create 
   validates_confirmation_of :password, message: "does not match"
   validates_length_of :password, :minimum => 4, message: "must be at least 4 characters long", :allow_blank => true

   # Scopes
    scope :active, ->{ where(active: true) }
    scope :inactive, ->{ where(active: false) }
    scope :alphabetical, ->{ order(:last_name, :first_name) }

   # Other methods
   # Makes an inactive User active
   def make_active
      self.active = true
      self.save!
   end
   
   # Makes an active User inactive
   def make_inactive
      self.active = false
      self.save!
   end

   # Returns a User's first then last name
   def proper_name
    first_name + " " + last_name
   end
  
   # Returns a User's last name then first name
   def name
    last_name + ", " + first_name
   end

   def role?(authorized_role)
    return false if status.nil?
    status.downcase.to_sym == authorized_role
   end

   # For use in authorizing with CanCan
   ROLES = [['Administrator', :admin],['Coach', :coach],['Leader', :leader]]

   # Login by username
   def self.authenticate(username, password)
    find_by_username(username).try(:authenticate, password)
   end

  # Don't allow any users to be destroyed
  before_destroy do 
    cannot_destroy_object()
  end

  # Callbacks
  before_save :reformat_phone

  private
  # We need to strip non-digits before saving to db
  def reformat_phone
    phone = self.phone.to_s 
    phone.gsub!(/[^0-9]/,"") 
    self.phone = phone
  end
  
end
