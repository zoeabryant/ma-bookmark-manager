
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

get '/users/reset_password' do
	erb :"users/reset_password"
end

post '/users/request_password_reset' do
	generate_password_token_for params[:email]
	# puts user.inspect

	redirect('/')
end

get '/users/reset_password/:token' do
	@token = params[:token]
	erb :"users/reset_password_with_token"
end

def generate_password_token_for email
	user = User.first(email: email)
	user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
	user.password_token_timestamp = Time.now
	user.save
end