class UsersController < ApplicationController
	def index
		if session[:id]
			@current_user = current_user
			@notifications =  notifications
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
		@current_user = current_user
		@notifications =  notifications
		@user = User.find(params[:id])
		@posts = @user.posts.select(:id, :content, :first_name, :last_name, :sender_id, :created_at).joins(:sender).includes(:comments)
		@friends = Friendship.where(user: @user).order(id: :desc).select(:id, :first_name, :last_name, :friend_id).joins(:friend)
		@friendship = @friends.collect{ |friend| friend.friend_id }.any?{ |id| id == session[:id] }
		@requested = @notifications.collect{ |notification| notification.sender_id }.any?{ |id| id == params[:id].to_i } || @user.notifications.where(sender: @current_user).any?
		@self = session[:id].eql?(params[:id].to_i)
	end

	def update
	end

	private
		def user_params
			params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
		end

		def current_user
			User.find(session[:id])
		end

		def notifications
			current_user.notifications.select(:id, :content, :request, :sender_id, :first_name, :last_name).joins(:sender)
		end
end

# current_user.notifications.joins(:sender).select("notifications.content, notifications.request, notifications.created_at")

