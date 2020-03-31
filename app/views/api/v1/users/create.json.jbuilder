json.set! @user_resource.class.to_s.underscore do
  json.partial! 'shared/api/v1/user', user: @user_resource
end
