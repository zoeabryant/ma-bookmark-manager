require 'spec_helper'

feature "User signs up" do

	scenario "when being logged out" do
		expect{ sign_up }.to change(User, :count).from(0).to(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "with a password that doesn't match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong')}.not_to change(User, :count)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Sorry, your passwords don't match")
	end

	scenario "with an email that is already registered" do
		expect{ sign_up }.to change(User, :count)
		expect{ sign_up }.not_to change(User, :count)
		expect(page).to have_content("This email is already taken")
	end

	def sign_up(email = "alice@example.com",
				password = "oranges!",
				password_confirmation = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		fill_in :email, with: email
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation
		click_button "Sign up"
	end

end