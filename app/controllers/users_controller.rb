class UsersController < ApplicationController
	def index
		if session[:id]
			@current_user = current_user
		end
	end

	def new
		if session[:id]
			redirect_to action:"show", id: session[:id]
		end
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			session[:id] = @user.id
			redirect_to @user, notice: "Welcome to your wall, #{@user.first_name}!"
		else
			render :new
		end
	end

	def show
		if session[:id]
			@current_user = current_user
			@user = User.includes([{posts: :comments}, :friends]).find(params[:id])
			@friends = @user.friends.order(id: :desc)
			@friendship = @friends.collect{ |friend| friend.id }.any?{ |id| id == session[:id] }
			@requested = @current_user.notifications.collect{ |notification| notification.sender.id }.any?{ |id| id == params[:id].to_i } || @user.notifications.where(sender: @current_user).any?
			@self = session[:id].eql?(params[:id].to_i)
		else
			redirect_to new_user_path
		end
	end

	def update
	end

	def destroy
	end

	def about
		if session[:id]
			@current_user = current_user
		end
	end

	private
		def user_params
			params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
		end

		def current_user
			User.includes(notifications: [:sender]).find(session[:id])
		end
end
