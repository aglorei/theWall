class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :sender, class_name: "User"

	validates :content, presence: true
	validates :request, presence: true, inclusion: { in: %w(friendships comments posts) }
end
