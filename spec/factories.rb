FactoryGirl.define do
  factory :user do
    username     "dsowers"
    email    "example@example.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :beta_invite do
    email "example@example.com"
  end

  factory :project do
    project_name "example"
    short_description "a short description"
    page_id nil
  end

  factory :notification do
    sender_id nil
    receiver_id nil
    notification_type nil
    notification_id nil
  end

  factory :page do
    name "mycelial"
    user_id nil
  end

  factory :like do
    user_id nil
    project_id nil
    username nil
  end

  factory :comment do
    project_id nil
    user_id nil
    comment nil
    username nil
  end
end
