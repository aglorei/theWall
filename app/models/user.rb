class User < ActiveRecord::Base
	has_secure_password
	has_many :posts
	has_many :comments
	has_many :friendships
	has_many :friends, through: :friendships
	has_many :notifications
	has_many :senders, through: :notifications

	validates :first_name, :last_name, presence: true, length: { in: 2..20 }
	validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
	validates :password, length: { minimum: 8 }

	def full_name
		"#{first_name} #{last_name}"
	end
end
