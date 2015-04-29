class SessionsController < ApplicationController
	def create
		@current_user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
		if @current_user
			@current_user.touch
			session[:id] = @current_user.id
			redirect_to @current_user
		else
			@current_user = User.new(email: params[:email])
			redirect_to new_user_path, flash: { error: "There are no users with those credentials", email: params[:email] }
		end
	end

	def destroy
		session.clear
		redirect_to root_url
	end
end
