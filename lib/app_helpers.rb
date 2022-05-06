# require needed files
require 'helpers/validations'
require 'helpers/activeable'
#require_relative 'helpers/deletions'
require './lib/helpers/deletions'

# create AppHelpers
module AppHelpers
  include AppHelpers::Validations
  include AppHelpers::Activeable::ClassMethods
  include AppHelpers::Activeable::InstanceMethods
  include AppHelpers::Deletions
end