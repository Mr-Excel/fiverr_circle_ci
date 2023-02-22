# frozen_string_literal: true

# generating a same user as organizer
FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { '11221122' }
    is_organizer { true }
  end
end
