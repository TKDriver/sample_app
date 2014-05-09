require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }

    let(:submit){"Create my account"}

    describe "with valid information"do
      before do
        fill_in "Name", with:"Example User"
        fill_in "Email", with:"user@examle.com"
        fill_in "Password", with:"foobar"
        fill_in "Confirmation", with: "foobar"
      end
      it "should create a user" do
        expect{click_button submit}.to change(User, :count)
      end
      describe "after saving the user" do
        before { click_button submit }

        it { should have_link('Sign out') }
        it { should have_title('Example User') }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }

        describe "followed by signout" do
          before {click_link "Sign out"}

          it {should have_link('Sign in')}
        end
      end
    end

    describe "with invalid information"do

      it "should not create a user" do
        expect{click_button submit}.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
      
    end
  end
end