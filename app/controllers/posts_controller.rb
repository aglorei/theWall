class PostsController < ApplicationController
	def create
		@post = Post.new(post_params)
		@post[:sender_id] = session[:id]

		if @post.save
			if @post[:user_id] != session[:id]
				Notification.create(content: " wrote a post on your wall", request: "posts", user_id: @post[:user_id], sender_id: session[:id])
			end
			redirect_to user_path(@post[:user_id])
		else
			redirect_to user_path(@post[:user_id]), flash: { errors: @post.errors.full_messages }
		end
	end

	def destroy
	end

	private
		def post_params
			params.require(:post).permit(:content, :user_id)
		end
end
