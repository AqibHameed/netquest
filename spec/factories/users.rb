FactoryBot.define do
  factory :user do
    username {Faker::Name.unique.name}
    email {Faker::Internet.email(domain: 'gmail.com')}
    password  {"password"}
    password_confirmation {"password"}
  end
end