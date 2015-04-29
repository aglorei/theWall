class Comment < ActiveRecord::Base
	belongs_to :post
	belongs_to :user
	belongs_to :commenter, class_name: 'User'

	validates :content, presence: true, length: { minimum: 2 }
end

# User.find(1).posts.find(1).comments.create(content: "Hey, you know what? This is pretty cool. - Tienlong", user: User.find(2), commenter: User.find(1))
