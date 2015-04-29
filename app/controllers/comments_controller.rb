class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)
		@comment[:commenter_id] = session[:id]

		if @comment.save
			# if commenter doesn't own post,
			if @comment[:user_id] != session[:id]
				# send notification for post's owner
				Notification.create(content: " commented on a post on your wall", request: "comments", user_id: @comment[:user_id], sender_id: session[:id])
			end
			# if commenter did not send post,
			if @comment.post[:sender_id] != session[:id]
				# send notification to post's sender
				Notification.create(content: " commented on your post", request: "comments", user_id: @comment.post[:sender_id], sender_id: session[:id])
			end
			redirect_to user_path(@comment[:user_id])
		else
			redirect_to user_path(@comment[:user_id]), flash: { errors: @comment.errors.full_messages }
		end
	end

	def destroy
	end

	private
		def comment_params
			params.require(:comment).permit(:content, :post_id, :user_id)
		end
end
