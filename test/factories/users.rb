FactoryBot.define do
  factory :user do
    name { 'default name' }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { 'password' }
  end
end
