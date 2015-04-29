class Post < ActiveRecord::Base
	belongs_to :user
	belongs_to :sender, class_name: 'User'
	has_many :comments

	validates :user_id, :sender_id, :content, presence: true
end

