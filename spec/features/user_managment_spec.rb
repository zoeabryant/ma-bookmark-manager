require 'spec_helper'
require_relative 'helpers/session'

def reload(resource)
	resource.model.get(resource.id)
end

include SessionHelpers

feature "User signs in" do

	before do
		User.create(email: "test@test.com",
					password: "test",
					password_confirmation: "test")
	end

	scenario "with the correct credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "with incorrect credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'wrong')
		expect(page).not_to have_content("Welcome, test@test.com")
	end

end

feature 'User signs out' do

	before do
		User.create(email: "test@test.com",
					password: "test",
					password_confirmation: "test")
	end

	scenario 'while being signed in' do
		sign_in('test@test.com', 'test')
		click_button "Sign out"
		expect(page).to have_content("Good bye!")
		expect(page).not_to have_content("Welcome, test@test.com")
	end

end

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

end

feature "User forgets password" do

	before do
		User.create(email: "test@test.com",
					password: "test",
					password_confirmation: "test")
	end

	scenario "Requests a password recovery token and sends an email" do
		user = User.first(email: 'test@test.com')
		request_new_password
		expect(user.password_token).not_to be nil
	end

	scenario "Visits their token page and resets password" do
		user = User.first(email: "test@test.com")
		user.password_token = "LOTSOFLETTERS"
		user.password_token_timestamp = Time.now
		user.save

		expect(user.password_token).not_to be nil
		reset_password

		user = reload(user)
		expect(user.password_token).to be nil
		expect(user.password_token_timestamp).to be nil

		sign_in('test@test.com', 'newpassword')
		expect(page).to have_content("Welcome, test@test.com")
	end

end
