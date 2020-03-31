json.id         user.id
json.first_name user.first_name
json.last_name  user.last_name
json.email      user.email
json.api_key    user.api_key
json.global_id  user.to_global_id.to_s
json.active     user.active
json.account_status user.account_status
json.user_type  user.class.to_s
json.avatar user, partial: "shared/api/v1/avatar", as: :user
