FactoryBot.define do
  factory :user do
    first_name {"Ed"}
    last_name {"Gruberman"}
    association :organization
    status {"coach"}
    username {"gruberman"}
    email {"abc@gmail.com"}
    password {"secret"}
    password_confirmation {"secret"}
    phone {"1234567890"}
    active {true}
    end
  end
  