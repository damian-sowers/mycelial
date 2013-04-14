FactoryGirl.define do
  factory :user do
    username     "dsowers"
    email    "example@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end