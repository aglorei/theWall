class NotificationsController < ApplicationController
	def create
		@notification = Notification.new(notification_params)
		@notification[:sender_id] = session[:id]
		@notification[:content] = " sent a friend request"

		if @notification.save
			redirect_to user_path(@notification[:user_id])
		else
			redirect_to user_path(@notification[:user_id]), flash: { errors: @notification.errors.full_messages }
		end
	end

	def destroy
		@notification = Notification.find(params[:id])
		@notification.destroy
		redirect_to new_user_path
	end

	private
		def notification_params
			params.require(:notification).permit(:request, :user_id)
		end
end
