# frozen_string_literal: true

json.id user.id
json.username user.username
json.email user.email
json.created_at user.created_at.iso8601
json.updated_at user.updated_at.iso8601
json.leader_ids user.leaders.pluck(:id)
json.follower_ids user.followers.pluck(:id)
json.image_url user.avatar_url
json.url user_url(user, format: :json)
