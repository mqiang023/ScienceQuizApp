FactoryBot.define do
  factory :event do
    date { "2021-04-17" }
    organization_id { 1 }
    active { true }
  end
end
