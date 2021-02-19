class Friendship < ApplicationRecord
  belongs_to :requestor, class_name: 'User'
  belongs_to :requested, class_name: 'User'

  def confirm_friend
    self.update_attributes(status: true)
    Friendship.create!(requested_id: self.requestor_id,
                       requestor_id: self.requested_id,
                       status: true)
  end
end
