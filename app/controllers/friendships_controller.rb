class FriendshipsController < ApplicationController
	def create
		@current_user = User.find(session[:id])
		@sender = User.find(friendship_params[:user_id])
		@forward = @sender.friendships.create(friend: @current_user)
		@backward = @current_user.friendships.create(friend: @sender)

		if @forward.save && @backward.save
			Notification.find_by(user: @current_user, sender: @sender).destroy
			redirect_to user_path(session[:id])
		else
			redirect_to user_path(@session[:id]), flash: { forward_errors: @forward.errors.full_messages, backward_errors: @backward.errors.full_messages, }
		end
	end

	def destroy
	end

	private
		def friendship_params
			params.require(:friendship).permit(:user_id)
		end
end
