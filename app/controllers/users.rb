
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
	generate_password_token_for params[:email]
	redirect('/')
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

	redirect('/')
end

def generate_password_token_for email
	user = User.first(email: email)
	user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
	user.password_token_timestamp = Time.now
	user.save
end