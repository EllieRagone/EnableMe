require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "Sign up page" do

    before { visit signup_path }

    it { should have_selector('h1',    text: "Sign up") }
    it { should have_selector('title', text: full_title("Sign up")) }

    describe "signing up" do
      let(:submit) { "Sign up" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "will display errors after submit" do
          before { click_button submit }
          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }

          describe "that do not include 'password digest'" do
            it { should_not have_content('digest') }
          end
        end
      end

      describe "with valid information" do
        before do
          fill_in "Steam User Name",  with: "rafer32"
          fill_in "Email",            with: "user@example.com"
          fill_in "Password",         with: "foobar"
          fill_in "Confirm Password", with: "foobar"
        end

        it "should create a user" do
          expect { click_button submit}.to change(User, :count).by(1)
        end

        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_selector('title', text: user.steam_name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
          it { should have_link('Sign out') }
        end
      end
    end
  end

  describe "profile page" do
    let(:user) {FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.steam_name) }
    it { should have_selector('title', text: full_title(user.steam_name)) }
  end

end
