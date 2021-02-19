class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :friendships, foreign_key: 'requestor_id'

  has_many :confirmed_friendships, -> { where status: true }, class_name: 'Friendship', foreign_key: 'requestor_id'
  has_many :friends, through: :confirmed_friendships, source: :requested

  # Users who needs to confirm friendship
  has_many :pending_friendships, -> { where status: false }, class_name: 'Friendship', foreign_key: 'requestor_id'
  has_many :pending_friends, through: :pending_friendships, source: :requested

  # Users who requested to be friends (needed for notifications)
  has_many :inverted_friendships, -> { where status: false }, class_name: 'Friendship', foreign_key: 'requested_id'
  has_many :friend_requests, through: :inverted_friendships, source: :requestor

  def friends_and_own_posts
    Post.where(user: (self.friends.to_a << self))
    # This will produce SQL query with IN. Something like: select * from posts where user_id IN (1,45,874,43);
  end
end
