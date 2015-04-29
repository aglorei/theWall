class PostsController < ApplicationController
	def create
		@post = Post.new(post_params)
		@post[:sender_id] = session[:id]

		if @post.save
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
