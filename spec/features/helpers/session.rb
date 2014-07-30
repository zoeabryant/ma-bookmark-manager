module SessionHelpers

	def sign_in(email, password)
		visit '/sessions/new'
		fill_in 'email', with: email
		fill_in 'password', with: password
		click_button 'Sign in'
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

	def request_new_password(email = "test@test.com")
		visit '/users/reset_password/request'
		expect(page.status_code).to eq(200)
		fill_in :email, with: email
		click_button "Reset Password"
	end

	def reset_password(password_token = "LOTSOFLETTERS",
						password = "newpassword",
						password_confirmation = "newpassword")
		# puts "/users/reset_password/token/#{password_token}"
		visit "/users/reset_password/token/#{password_token}"
		expect(page.status_code).to eq(200)
		fill_in :password_token, with: password_token
		fill_in :password, with: password
		fill_in :password_confirmation, with: password_confirmation

		click_button "Reset Password"
	end

end