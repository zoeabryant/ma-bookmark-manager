
get '/users/new' do
	@user = User.new
	erb :"users/new"
end

post '/users' do

	@user = User.new(email: params[:email],
		password: params[:password],
		password_confirmation: params[:password_confirmation])
	if @user.save
		session[:user_id] = @user.id
		redirect to('/')
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :"users/new"
	end

end

get '/users/reset_password/request' do
	erb :"users/reset_password/request"
end

post '/users/reset_password' do
	user = User.first(email: params[:email])

	if user
		puts generate_password_token_for params[:email]

		flash[:notice] = "We have sent an email to #{params[:email]} with instructions on how to reset your password"
		redirect('/')
	else
		flash[:notice] = "We could not find the email #{params[:email]} in our registered users"
		erb :"users/reset_password/request"
	end
end

get '/users/reset_password/token/:token' do
	@token = params[:token]
	erb :"users/reset_password/token/with_token"
end

post '/users/reset_password/token' do
	user = User.first(password_token: params[:password_token])

	user.update(password: params[:password],
		password_confirmation: params[:password_confirmation],
		password_token: nil,
		password_token_timestamp: nil)

	redirect('/sessions/new')
end

def generate_password_token_for email
	user = User.first(email: email)
	user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
	user.password_token_timestamp = Time.now
	user.save
	send_password_message_to email, user.password_token
	user.password_token
end

def send_password_message_to email, password_token
	RestClient.post "https://api:#{ENV["MAILGUN_API_KEY"]}"\
	"@api.mailgun.net/v2/app27923439.mailgun.org/messages",
	:from => "Excited User <me@app27923439.mailgun.org>",
	:to => email,
	:subject => "Password Reset",
	:text => "Please go to the following URL to reset your password /users/reset_password/token/#{password_token}"
end