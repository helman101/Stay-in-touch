module FriendshipsHelper
  def friendship_exist?(user, friend)
    Friendship.where(requestor_id: user, requested_id: friend, status: false).first
  end

  def friendship(user, friend)
    Friendship.where(requestor_id: user, requested_id: friend).first
  end

  def status?(user, friend)
    friendship = Friendship.where(requestor_id: user, requested_id: friend).first
    return false if friendship.nil?

    friendship.status
  end

  def requestor?(requestor)
    current_user.requestors.exists?(requestor)
  end

  def make_request(current, user)
    if current != user
      if friendship_exist?(current, user)
        'Waiting for friend'
      elsif status?(current, user)
        'You are friends'
      elsif !friendship_exist?(current, user)
        link_to 'Friend request', friendships_path(requestor_id: current, requested_id: user), method: :create
      end
    end
  end

  def accept_request(current, user)
    if requestor?(user) && !status?(current, user)
      link_to 'Accept request', friendship_path(id: friendship(user, current).id, requested_id: user), method: :patch
    end
  end

  def cancel_request(current, user)
    if requestor?(user) && !status?(current, user)
      link_to 'Reject request', friendship_path(id: friendship(user, current).id), method: :delete
    end
  end
end
