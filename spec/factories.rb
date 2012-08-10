FactoryGirl.define do
  factory :user do
    steam_name            "rafer32"
    email                 "user@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end