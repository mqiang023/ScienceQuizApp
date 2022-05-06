FactoryBot.define do
  factory :team do
    name { "ACAC 1" }
    association :organization
    association :coach
    division { "senior" }
    active { true }
  end
end
